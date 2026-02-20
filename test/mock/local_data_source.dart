import 'dart:io';

import 'package:habit_tracker/data/local_data_source.dart';
import 'package:shared_preferences/src/shared_preferences_async.dart';

class MockLocalDataSourceSuccess implements LocalDataSource {
  @override
  Future<String?> get() {
    final jsonString = '''
[
  {
    "id": 1,
    "title": "Leer 30 minutos",
    "isCompleted": true,
    "completedAt": "2026-02-16T14:30:00.000Z"
  },
  {
    "id": 2,
    "title": "Ir al gimnasio",
    "isCompleted": false,
    "completedAt": null
  }
]
''';
    return Future.value(jsonString);
  }

  @override
  Future<void> set(String jsonString) async {}

  @override
  // TODO: implement prefs
  SharedPreferencesAsync get prefs => throw UnimplementedError();
}

class MockLocalDataSourceError implements LocalDataSource {
  @override
  Future<String?> get() {
    throw SocketException("Error");
  }

  @override
  Future<void> set(String jsonString) {
    throw SocketException("Error");
  }

  @override
  // TODO: implement prefs
  SharedPreferencesAsync get prefs => throw UnimplementedError();
}
