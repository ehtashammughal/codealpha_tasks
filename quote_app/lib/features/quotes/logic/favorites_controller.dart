import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers.dart';

/// Live stream of favorited quotes, used by the Favorites tab.
final favoritesProvider = StreamProvider.autoDispose<List<Quote>>((ref) {
  return ref.watch(databaseProvider).quotesDao.watchFavorites();
});
