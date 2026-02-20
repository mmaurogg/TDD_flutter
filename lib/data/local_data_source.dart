import 'package:shared_preferences/shared_preferences.dart';

final SharedPreferencesAsync prefs = SharedPreferencesAsync();

class LocalDataSource {
  static const String key = "habits";

  Future<String?> get() async {
    final result = await prefs.getString(key);
    return result;
  }
}
