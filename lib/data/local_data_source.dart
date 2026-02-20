import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  static const String key = "habits";

  LocalDataSource({required this.prefs});

  final SharedPreferencesAsync prefs;

  Future<String?> get() async {
    final result = await prefs.getString(key);
    return result;
  }

  Future<void> set(String jsonString) async {
    await prefs.setString(key, jsonString);
  }
}
