import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/quotes_table.dart';

part 'quotes_dao.g.dart';

@DriftAccessor(tables: [Quotes])
class QuotesDao extends DatabaseAccessor<AppDatabase> with _$QuotesDaoMixin {
  QuotesDao(super.db);

  /// Inserts the quote; silently ignored if (content, author) already exists.
  Future<void> insertQuote(QuotesCompanion quote) =>
      into(quotes).insert(quote, mode: InsertMode.insertOrIgnore);

  Future<Quote?> findQuote(String content, String author) {
    return (select(quotes)
          ..where((q) => q.content.equals(content) & q.author.equals(author)))
        .getSingleOrNull();
  }

  /// Random cached quote, optionally skipping the one currently shown.
  Future<Quote?> getRandomCached({int? excludeId}) {
    final query = select(quotes);
    if (excludeId != null) {
      query.where((q) => q.id.isNotValue(excludeId));
    }
    query
      ..orderBy([(_) => OrderingTerm.random()])
      ..limit(1);
    return query.getSingleOrNull();
  }
}
