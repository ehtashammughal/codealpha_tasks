import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/quote_controller.dart';

class QuoteScreen extends ConsumerWidget {
  const QuoteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quote = ref.watch(quoteControllerProvider);
    final scheme = Theme.of(context).colorScheme;
    final current = quote.valueOrNull; // keeps the old quote while loading

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.primaryContainer.withOpacity(0.55),
              scheme.surface,
              scheme.tertiaryContainer.withOpacity(0.45),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  children: [
                    // Fixed header
                    Text(
                      'QUOTE OF THE MOMENT',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            letterSpacing: 3,
                            color: scheme.onSurfaceVariant,
                          ),
                    ),

                    // Flexible middle: card grows/shrinks here without
                    // moving the buttons. Very long quotes scroll.
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: _QuoteCard(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              // Old text fades out in the first half, new text
                              // fades in during the second half (no overlap).
                              // Same formula works for both directions.
                              transitionBuilder: (child, anim) => FadeTransition(
                                opacity: anim.drive(CurveTween(
                                  curve: const Interval(0.5, 1.0,
                                      curve: Curves.easeOut),
                                )),
                                child: child,
                              ),
                              child: current != null
                                  ? _QuoteBody(
                                      key: ValueKey(current.id),
                                      content: current.content,
                                      author: current.author,
                                    )
                                  : quote.hasError
                                      ? Text(
                                          quote.error
                                              .toString()
                                              .replaceFirst('Exception: ', ''),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: scheme.error),
                                        )
                                      : const Padding(
                                          padding: EdgeInsets.all(48),
                                          child: CircularProgressIndicator(),
                                        ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Fixed footer: buttons never move
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filledTonal(
                          tooltip: 'Copy quote',
                          onPressed: current == null
                              ? null
                              : () {
                                  Clipboard.setData(ClipboardData(
                                    text: '"${current.content}" — ${current.author}',
                                  ));
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(const SnackBar(
                                      content: Text('Quote copied'),
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 1),
                                    ));
                                },
                          icon: const Icon(Icons.copy_rounded),
                        ),
                        const SizedBox(width: 12),
                        FilledButton.icon(
                          onPressed: quote.isLoading
                              ? null
                              : () => ref
                                  .read(quoteControllerProvider.notifier)
                                  .newQuote(),
                          icon: quote.isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.auto_awesome),
                          label: const Text('New Quote'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh.withOpacity(0.85),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: scheme.outlineVariant.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withOpacity(0.15),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      // Smoothly grows/shrinks the card when the quote length changes.
      child: AnimatedSize(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: child,
      ),
    );
  }
}

class _QuoteBody extends StatelessWidget {
  const _QuoteBody({super.key, required this.content, required this.author});
  final String content;
  final String author;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final initial = author.isNotEmpty ? author[0].toUpperCase() : '?';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.format_quote_rounded, size: 48, color: scheme.primary),
        const SizedBox(height: 12),
        Text(
          content,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 24),
        Divider(color: scheme.outlineVariant, indent: 60, endIndent: 60),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: scheme.primary,
              child: Text(
                initial,
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                author,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}