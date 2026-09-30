import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

import '../app_database.dart';

AppDatabase constructDb() {
  final connection = DatabaseConnection.delayed(
    Future(() async {
      final result = await WasmDatabase.open(
        databaseName: 'flashcard_database',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.dart.js'),
      );

      return result.resolvedExecutor;
    }),
  );

  return AppDatabase(connection);
}