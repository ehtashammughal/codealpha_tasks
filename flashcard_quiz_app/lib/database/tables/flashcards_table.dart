import 'package:drift/drift.dart';

@DataClassName('FlashcardData')
class Flashcards extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get question => text()();

  TextColumn get answer => text()();
}
