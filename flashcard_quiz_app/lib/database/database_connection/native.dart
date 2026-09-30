import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../app_database.dart';

AppDatabase constructDb() {
  final db = LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File(
      p.join(directory.path, 'flashcard_database.sqlite'),
    );

    return NativeDatabase.createInBackground(file);
  });

  return AppDatabase(db);
}