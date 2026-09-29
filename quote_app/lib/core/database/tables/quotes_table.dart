import 'package:drift/drift.dart';

// NOTE: column is `content`, not `text` — `text` clashes with Drift's text() builder.
class Quotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
  TextColumn get author => text()();
  DateTimeColumn get fetchedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isFavorite =>
      boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {content, author},
      ];
}
