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

  Future<Quote?> getById(int id) =>
      (select(quotes)..where((q) => q.id.equals(id))).getSingleOrNull();

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

  /// Flips the favorite flag for one quote and returns the updated row.
  Future<Quote> toggleFavorite(int id) async {
    final current = await getById(id);
    if (current == null) {
      throw StateError('Quote $id not found');
    }
    final updated = !current.isFavorite;
    await (update(quotes)..where((q) => q.id.equals(id)))
        .write(QuotesCompanion(isFavorite: Value(updated)));
    return current.copyWith(isFavorite: updated);
  }

  /// Live list of favorited quotes, most recently fetched first.
  Stream<List<Quote>> watchFavorites() {
    return (select(quotes)
          ..where((q) => q.isFavorite.equals(true))
          ..orderBy([(q) => OrderingTerm.desc(q.fetchedAt)]))
        .watch();
  }
}
