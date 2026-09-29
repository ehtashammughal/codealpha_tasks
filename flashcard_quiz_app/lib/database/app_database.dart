import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/flashcards_table.dart';
import 'daos/flashcard_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Flashcards], daos: [FlashcardDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) async {
      await migrator.createAll();
    },

    onUpgrade: (Migrator migrator, int from, int to) async {
      // Add database migrations here when schema changes.
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File(p.join(directory.path, 'flashcards.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
