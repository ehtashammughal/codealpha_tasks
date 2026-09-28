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
}

final quoteControllerProvider =
    AsyncNotifierProvider<QuoteController, Quote>(QuoteController.new);
