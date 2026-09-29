// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_dao.dart';

// ignore_for_file: type=lint
mixin _$FlashcardDaoMixin on DatabaseAccessor<AppDatabase> {
  $FlashcardsTable get flashcards => attachedDatabase.flashcards;
  FlashcardDaoManager get managers => FlashcardDaoManager(this);
}

class FlashcardDaoManager {
  final _$FlashcardDaoMixin _db;
  FlashcardDaoManager(this._db);
  $$FlashcardsTableTableManager get flashcards =>
      $$FlashcardsTableTableManager(_db.attachedDatabase, _db.flashcards);
}
