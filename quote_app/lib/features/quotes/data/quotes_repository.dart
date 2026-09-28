import '../../../core/database/app_database.dart';
import 'quotes_api.dart';
import 'quotes_dao.dart';

class QuotesRepository {
  QuotesRepository(this._api, this._dao);
  final QuotesApi _api;
  final QuotesDao _dao;

  /// Tries the API first (and caches the result). If offline or the API
  /// fails, falls back to a random cached quote. Throws only when both fail.
  Future<Quote> getNewQuote({int? excludeId}) async {
    try {
      // A few attempts, so we don't show the same quote twice in a row.
      for (var i = 0; i < 3; i++) {
        final dto = await _api.fetchRandom();
        await _dao.insertQuote(
          QuotesCompanion.insert(content: dto.content, author: dto.author),
        );
        final saved = await _dao.findQuote(dto.content, dto.author);
        if (saved != null && saved.id != excludeId) return saved;
      }
    } catch (_) {
      // fall through to cache
    }

    final cached = await _dao.getRandomCached(excludeId: excludeId);
    if (cached != null) return cached;
    throw Exception('No internet connection and no saved quotes yet.');
  }
}
