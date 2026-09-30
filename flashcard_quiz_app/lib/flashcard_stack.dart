import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_theme.dart';
import 'flashcard.dart';

const List<List<Color>> _gradients = [
  [Color(0xFF7657FF), Color(0xFF4D7CFE)],
  [Color(0xFFFF4F81), Color(0xFFFF8A65)],
  [Color(0xFF00BFA6), Color(0xFF0083FF)],
  [Color(0xFF8B5CF6), Color(0xFFD946EF)],
  [Color(0xFF0891B2), Color(0xFF14B8A6)],
];

class FlashcardStack extends StatefulWidget {
  final List<Flashcard> cards;
  final Future<void> Function(Flashcard card) onEdit;
  final Future<void> Function(Flashcard card) onDelete;

  const FlashcardStack({
    super.key,
    required this.cards,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<FlashcardStack> createState() => _FlashcardStackState();
}

class _FlashcardStackState extends State<FlashcardStack> {
  // How much of the screen one page takes. The rest shows the neighbors.
  static const double _viewportFraction = 0.84;

  late final PageController _controller;

  /// Current card index. Only the header / buttons listen to this,
  /// so a swipe never rebuilds the whole screen.
  final ValueNotifier<int> _index = ValueNotifier<int>(0);

  /// Index of the card currently showing its answer (-1 = none).
  final ValueNotifier<int> _revealed = ValueNotifier<int>(-1);

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: _viewportFraction);
  }

  @override
  void didUpdateWidget(covariant FlashcardStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    final length = widget.cards.length;

    if (length == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _index.value = 0;
        _revealed.value = -1;
      });
      return;
    }

    if (_index.value >= length) {
      final last = length - 1;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_controller.hasClients) {
          _controller.jumpToPage(last);
        }
        _index.value = last;
        _revealed.value = -1;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _index.dispose();
    _revealed.dispose();
    super.dispose();
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  double get _currentPage {
    if (_controller.hasClients && _controller.position.haveDimensions) {
      return _controller.page ?? _index.value.toDouble();
    }
    return _index.value.toDouble();
  }

  /// Always clamped, so spamming the buttons can never go out of range.
  void _go(int delta) {
    if (!_controller.hasClients || widget.cards.isEmpty) return;

    final target = (_currentPage.round() + delta).clamp(
      0,
      widget.cards.length - 1,
    );

    _controller.animateToPage(
      target,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _toggleAnswer(int index) {
    _revealed.value = _revealed.value == index ? -1 : index;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.cards.isEmpty) {
      return _buildEmptyState(theme);
    }

    return Focus(
      autofocus: kIsWeb,
      onKeyEvent: (node, event) {
        if (!kIsWeb || event is! KeyDownEvent) {
          return KeyEventResult.ignored;
        }

        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _go(-1);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _go(1);
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      child: Column(
        children: [
          const SizedBox(height: 8),
          _buildHeader(theme),
          const SizedBox(height: 10),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final cardHeight = math.min(
                  constraints.maxHeight * 0.96,
                  600.0,
                );

                return PageView.builder(
                  controller: _controller,
                  clipBehavior: Clip.none,
                  physics: const PageScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  itemCount: widget.cards.length,
                  onPageChanged: (i) {
                    _index.value = i;
                    _revealed.value = -1;
                  },
                  findChildIndexCallback: (key) {
                    if (key is ValueKey) {
                      final i = widget.cards.indexWhere(
                        (c) => c.id == key.value,
                      );
                      return i < 0 ? null : i;
                    }
                    return null;
                  },
                  itemBuilder: (context, i) {
                    return _buildPage(
                      index: i,
                      screenWidth: width,
                      cardHeight: cardHeight,
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          _buildSwipeHint(theme),
          const SizedBox(height: 8),
          ValueListenableBuilder<bool>(
            valueListenable: AppTheme.showCardNavigationButtons,
            builder: (context, showButtons, child) {
              if (!showButtons) {
                return const SizedBox(height: 8);
              }

              return _buildNavigationButtons(theme);
            },
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  // ============================================================
  // PAGE
  // ============================================================

  Widget _buildPage({
    required int index,
    required double screenWidth,
    required double cardHeight,
  }) {
    final card = widget.cards[index];

    return AnimatedBuilder(
      // Stable key: a card keeps its identity for its whole life.
      key: ValueKey(card.id),
      animation: _controller,
      // Built once. Scrolling only re-runs the cheap Transform below,
      // the card itself is never rebuilt or repainted while swiping.
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: RepaintBoundary(
            child: SizedBox(
              width: 430,
              height: cardHeight,
              child: _CardFace(
                card: card,
                index: index,
                revealed: _revealed,
                onToggle: () => _toggleAnswer(index),
                onEdit: () => widget.onEdit(card),
                onDelete: () => widget.onDelete(card),
              ),
            ),
          ),
        ),
      ),
      builder: (context, child) {
        // d: -1 (card is on the right) ... 0 (centered) ... 1 (on the left)
        final d = (_currentPage - index).clamp(-1.0, 1.0);
        final a = d.abs();

        return IgnorePointer(
          // Only the centered card reacts to taps.
          ignoring: a > 0.5,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..translate(d * screenWidth * 0.03, 10 * a)
              ..scale(1 - 0.12 * a),
            child: child,
          ),
        );
      },
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Text(
            'YOUR DECK',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.3,
            ),
          ),
          const Spacer(),
          ValueListenableBuilder<int>(
            valueListenable: _index,
            builder: (context, index, _) {
              final total = widget.cards.length;
              final shown = (index + 1).clamp(1, total);

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '$shown / $total',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NAVIGATION BUTTONS
  // ============================================================

  Widget _buildNavigationButtons(ThemeData theme) {
    return ValueListenableBuilder<int>(
      valueListenable: _index,
      builder: (context, index, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _roundButton(
              theme: theme,
              icon: Icons.arrow_back_rounded,
              enabled: index > 0,
              onTap: () => _go(-1),
            ),
            const SizedBox(width: 22),
            _roundButton(
              theme: theme,
              icon: Icons.arrow_forward_rounded,
              enabled: index < widget.cards.length - 1,
              onTap: () => _go(1),
            ),
          ],
        );
      },
    );
  }

  Widget _roundButton({
    required ThemeData theme,
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return Material(
      color: enabled
          ? theme.colorScheme.primary.withValues(alpha: 0.10)
          : theme.colorScheme.onSurface.withValues(alpha: 0.05),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Icon(
            icon,
            size: 20,
            color: enabled
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.25),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SWIPE HINT
  // ============================================================

  Widget _buildSwipeHint(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.swipe_rounded,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 7),
        Text(
          'SWIPE TO EXPLORE',
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.style_rounded,
              size: 55,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your deck is waiting!',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first flashcard to get started.',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ==============================================================
// CARD FACE
// ==============================================================

class _CardFace extends StatelessWidget {
  final Flashcard card;
  final int index;
  final ValueNotifier<int> revealed;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CardFace({
    required this.card,
    required this.index,
    required this.revealed,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _gradients[index % _gradients.length];

    return GestureDetector(
      onTap: onToggle,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: 0.34),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Stack(
            children: [
              Positioned(right: -65, top: -65, child: _decorationCircle(190)),
              Positioned(left: -70, bottom: -80, child: _decorationCircle(210)),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    _buildTopRow(),

                    // Only this part rebuilds when the answer is toggled.
                    Expanded(
                      child: ValueListenableBuilder<int>(
                        valueListenable: revealed,
                        builder: (context, value, _) {
                          return _buildCenter(value == index);
                        },
                      ),
                    ),

                    ValueListenableBuilder<int>(
                      valueListenable: revealed,
                      builder: (context, value, _) {
                        return _buildFooter(value == index);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 14),
              SizedBox(width: 6),
              Text(
                'FLASHCARD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        _cardIconButton(
          icon: Icons.edit_rounded,
          tooltip: 'Edit',
          onTap: onEdit,
        ),
        const SizedBox(width: 8),
        _cardIconButton(
          icon: Icons.delete_outline_rounded,
          tooltip: 'Delete',
          onTap: onDelete,
        ),
      ],
    );
  }

  Widget _buildCenter(bool isAnswerVisible) {
    final text = isAnswerVisible ? card.answer : card.question;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Column(
            key: ValueKey(isAnswerVisible),
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isAnswerVisible
                      ? Icons.lightbulb_rounded
                      : Icons.psychology_rounded,
                  color: Colors.white,
                  size: 31,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isAnswerVisible ? 'ANSWER' : 'QUESTION',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.70),
                  fontSize: 11,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  height: 1.42,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(bool isAnswerVisible) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.touch_app_rounded, color: Colors.white, size: 17),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              isAnswerVisible
                  ? 'Tap to see the question'
                  : 'Tap to reveal the answer',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withValues(alpha: 0.18),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }

  Widget _decorationCircle(double size) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.07),
        ),
      ),
    );
  }
}
