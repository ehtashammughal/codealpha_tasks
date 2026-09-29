import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers.dart';
import '../data/quotes_api.dart';
import '../data/quotes_repository.dart';

final quotesRepositoryProvider = Provider<QuotesRepository>((ref) {
  return QuotesRepository(
    QuotesApi(ref.watch(dioProvider)),
    ref.watch(databaseProvider).quotesDao,
  );
});

class QuoteController extends AsyncNotifier<Quote> {
  @override
  Future<Quote> build() => ref.read(quotesRepositoryProvider).getNewQuote();

  Future<void> newQuote() async {
    final currentId = state.valueOrNull?.id;
    state = const AsyncLoading<Quote>().copyWithPrevious(state);
    state = await AsyncValue.guard(
      () => ref.read(quotesRepositoryProvider).getNewQuote(excludeId: currentId),
    );
  }

  /// Toggles favorite on the quote currently shown. Local, no API call —
  /// updates state directly instead of refetching.
  Future<void> toggleFavorite() async {
    final current = state.valueOrNull;
    if (current == null) return;
    final dao = ref.read(databaseProvider).quotesDao;
    final updated = await dao.toggleFavorite(current.id);
    state = AsyncData(updated);
  }
}

final quoteControllerProvider =
    AsyncNotifierProvider<QuoteController, Quote>(QuoteController.new);
