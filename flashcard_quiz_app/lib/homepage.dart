
import 'package:flutter/material.dart';
import '../database/database_connection/shared.dart';
import 'flashcard_stack.dart';
import 'flashcard.dart';
import 'database/app_database.dart';
import 'database/daos/flashcard_dao.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late final AppDatabase database;
  late final FlashcardDao dao;

  List<Flashcard> flashcards = [];

  bool isLoading = true;

 @override
void initState() {
  super.initState();

  database = constructDb();
  dao = FlashcardDao(database);

  loadFlashcards();
}

  // ==========================================================
  // LOAD FLASHCARDS
  // ==========================================================

  Future<void> loadFlashcards() async {
    try {
      final data = await dao.getAllFlashcards();

      if (!mounted) return;

      setState(() {
        flashcards = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error loading flashcards: $e',
          ),
        ),
      );
    }
  }

    // ==========================================================
  // ADD FLASHCARD
  // ==========================================================

  Future<void> addFlashcard() async {
    final questionController = TextEditingController();
    final answerController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final colors = Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),

          titlePadding: const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            8,
          ),

          contentPadding: const EdgeInsets.fromLTRB(
            24,
            12,
            24,
            8,
          ),

          actionsPadding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            18,
          ),

          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.add_card_rounded,
                  color: colors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Add Flashcard',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          content: SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // QUESTION
                TextField(
                  controller: questionController,
                  autofocus: true,
                  minLines: 2,
                  maxLines: 5,
                  textCapitalization:
                      TextCapitalization.sentences,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    labelText: 'Question',
                    hintText: 'Enter your question...',
                    prefixIcon: const Icon(
                      Icons.help_outline_rounded,
                    ),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor:
                        colors.primary.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(
                        color: colors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ANSWER
                TextField(
                  controller: answerController,
                  minLines: 2,
                  maxLines: 5,
                  textCapitalization:
                      TextCapitalization.sentences,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    labelText: 'Answer',
                    hintText: 'Enter the answer...',
                    prefixIcon: const Icon(
                      Icons.lightbulb_outline_rounded,
                    ),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor:
                        colors.primary.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(
                        color: colors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),

           ElevatedButton.icon(
  onPressed: () async {
    final question = questionController.text.trim();
    final answer = answerController.text.trim();

    // Check empty fields
    if (question.isEmpty || answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter both a question and an answer.',
          ),
        ),
      );
      return;
    }

    try {
      // Add flashcard to database
      await dao.addFlashcard(
        question: question,
        answer: answer,
      );

      // Make sure dialog is still open
      if (!dialogContext.mounted) return;

      // Close dialog
      Navigator.of(dialogContext).pop(true);
    } catch (e) {
      // Show database error
      if (!dialogContext.mounted) return;

      ScaffoldMessenger.of(dialogContext).showSnackBar(
        SnackBar(
          content: Text(
            'Error adding flashcard: $e',
          ),
        ),
      );
    }
  },
  icon: const Icon(
    Icons.add_rounded,
  ),
  label: const Text(
    'Add',
  ),
),
          ],
        );
      },
    );

    //questionController.dispose();
   // answerController.dispose();

    if (result == true) {
      await loadFlashcards();
    }
  }

  // ==========================================================
  // UPDATE FLASHCARD
  // ==========================================================

  Future<void> updateFlashcard(
    Flashcard flashcard,
  ) async {
    final questionController = TextEditingController(
      text: flashcard.question,
    );

    final answerController = TextEditingController(
      text: flashcard.answer,
    );

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final colors = Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),

          titlePadding: const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            8,
          ),

          contentPadding: const EdgeInsets.fromLTRB(
            24,
            12,
            24,
            8,
          ),

          actionsPadding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            18,
          ),

          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.edit_rounded,
                  color: colors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Edit Flashcard',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          content: SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // QUESTION
                TextField(
                  controller: questionController,
                  minLines: 2,
                  maxLines: 5,
                  textCapitalization:
                      TextCapitalization.sentences,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    labelText: 'Question',
                    hintText: 'Enter your question...',
                    prefixIcon: const Icon(
                      Icons.help_outline_rounded,
                    ),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor:
                        colors.primary.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(
                        color: colors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ANSWER
                TextField(
                  controller: answerController,
                  minLines: 2,
                  maxLines: 5,
                  textCapitalization:
                      TextCapitalization.sentences,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    labelText: 'Answer',
                    hintText: 'Enter the answer...',
                    prefixIcon: const Icon(
                      Icons.lightbulb_outline_rounded,
                    ),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor:
                        colors.primary.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(
                        color: colors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton.icon(
              onPressed: () async {
                final question =
                    questionController.text.trim();

                final answer =
                    answerController.text.trim();

                if (question.isEmpty || answer.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter both a question and an answer.',
                      ),
                    ),
                  );
                  return;
                }

                final updatedFlashcard = Flashcard(
                  id: flashcard.id,
                  question: question,
                  answer: answer,
                );

                await dao.updateFlashcard(
                  updatedFlashcard,
                );

                if (!dialogContext.mounted) return;

                Navigator.of(dialogContext).pop(true);
              },
              icon: const Icon(
                Icons.check_rounded,
              ),
              label: const Text('Update'),
            ),
          ],
        );
      },
    );

    //questionController.dispose();
    //answerController.dispose();

    if (result == true) {
      await loadFlashcards();
    }
  }


  
  // ==========================================================
  // DELETE FLASHCARD
  // ==========================================================

  Future<void> deleteFlashcard(
    Flashcard flashcard,
  ) async {
    if (flashcard.id == null) {
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Icon(
            Icons.delete_forever_rounded,
            size: 42,
            color: Theme.of(context)
                .colorScheme
                .error,
          ),

          title: const Text(
            'Delete Flashcard?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),

          content: const Text(
            'This flashcard will be permanently '
            'removed from your deck.',
            textAlign: TextAlign.center,
          ),

          actionsAlignment:
              MainAxisAlignment.spaceEvenly,

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),

            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor:
                    Theme.of(context)
                        .colorScheme
                        .error,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    await dao.deleteFlashcard(
      flashcard.id!,
    );

    await loadFlashcards();
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    database.close();
    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
    appBar: AppBar(
  elevation: 0,
  scrolledUnderElevation: 0,
  backgroundColor: Colors.transparent,
  surfaceTintColor: Colors.transparent,
  toolbarHeight: 76,
  titleSpacing: 20,

  title: Row(
    children: [
      Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors.primary,
              colors.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.20),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(
          Icons.style_rounded,
          color: Colors.white,
          size: 23,
        ),
      ),

      const SizedBox(width: 13),

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'FlashCard',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),

          Text(
            'Learn something new today',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ],
  ),

  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 18),
      child: Material(
        color: colors.primary.withValues(alpha: 0.10),
        shape: const CircleBorder(),

        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: addFlashcard,

          child: Padding(
            padding: const EdgeInsets.all(11),

            child: Icon(
              Icons.add_rounded,
              color: colors.primary,
              size: 24,
            ),
          ),
        ),
      ),
    ),
  ],
),
      body: _buildBody(),
    );
  }

  // ==========================================================
  // BODY
  // ==========================================================

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (flashcards.isEmpty) {
      return _buildEmptyState();
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          8,
        ),

      child: FlashcardStack(
  cards: flashcards,
  onEdit: updateFlashcard,
  onDelete: deleteFlashcard,
),
      ),
    );
  }

  // ==========================================================
  // EMPTY STATE
  // ==========================================================

  Widget _buildEmptyState() {
    final colors =
        Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              padding:
                  const EdgeInsets.all(25),

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colors.primary,
                    colors.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors.primary
                        .withValues(alpha: 0.25),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),

              child: const Icon(
                Icons.style_rounded,
                color: Colors.white,
                size: 55,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Your deck is empty',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Create your first flashcard and '
              'start learning.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: addFlashcard,
              icon: const Icon(
                Icons.add_rounded,
              ),
              label: const Text(
                'Create Flashcard',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

