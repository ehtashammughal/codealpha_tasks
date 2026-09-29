import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/flashcards_table.dart';
import '../../flashcard.dart';

part 'flashcard_dao.g.dart';

@DriftAccessor(tables: [Flashcards])
class FlashcardDao extends DatabaseAccessor<AppDatabase>
    with _$FlashcardDaoMixin {
  FlashcardDao(super.db);

  // Get all flashcards
  Future<List<Flashcard>> getAllFlashcards() async {
    final data = await select(flashcards).get();

    return data.map((item) {
      return Flashcard(
        id: item.id,
        question: item.question,
        answer: item.answer,
      );
    }).toList();
  }

  // Watch all flashcards
  Stream<List<Flashcard>> watchAllFlashcards() {
    return select(flashcards).watch().map((data) {
      return data.map((item) {
        return Flashcard(
          id: item.id,
          question: item.question,
          answer: item.answer,
        );
      }).toList();
    });
  }

  // Get one flashcard by ID
  Future<Flashcard?> getFlashcardById(int id) async {
    final result = await (select(
      flashcards,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

    if (result == null) {
      return null;
    }

    return Flashcard(
      id: result.id,
      question: result.question,
      answer: result.answer,
    );
  }

  // Add flashcard
  Future<int> addFlashcard({required String question, required String answer}) {
    return into(flashcards)
        .insert(FlashcardsCompanion.insert(question: question, answer: answer));
  }

  // Update flashcard
  Future<bool> updateFlashcard(Flashcard flashcard) {
    if (flashcard.id == null) {
      return Future.value(false);
    }

    return update(flashcards).replace(
      FlashcardData(
        id: flashcard.id!,
        question: flashcard.question,
        answer: flashcard.answer,
      ),
    );
  }

  // Delete flashcard
  Future<int> deleteFlashcard(int id) {
    return (delete(flashcards)..where((tbl) => tbl.id.equals(id))).go();
  }
}
