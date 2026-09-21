import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  static const String key = "habits";

  LocalDataSource({SharedPreferencesAsync? prefs})
    : _prefs = prefs ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _prefs;

  Future<String?> get() async {
    final result = await _prefs.getString(key);
    return result;
  }

  Future<void> set(String jsonString) async {
    await _prefs.setString(key, jsonString);
  }
}
