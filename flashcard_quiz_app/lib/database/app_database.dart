import 'package:drift/drift.dart';

import 'database_connection/shared.dart';
import 'tables/flashcards_table.dart';
import 'daos/flashcard_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Flashcards,
  ],
  daos: [
    FlashcardDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future database changes go here.
        },
      );
}