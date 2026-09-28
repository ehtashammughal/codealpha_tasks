import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../features/quotes/data/quotes_dao.dart';
import 'tables/quotes_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Quotes], daos: [QuotesDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'app_db'));

  @override
  int get schemaVersion => 1;
}
