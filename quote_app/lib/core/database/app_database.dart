import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../features/quotes/data/quotes_dao.dart';
import 'tables/quotes_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Quotes], daos: [QuotesDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  // v1 -> v2: added `isFavorite` column to Quotes.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(quotes, quotes.isFavorite);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'app_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
