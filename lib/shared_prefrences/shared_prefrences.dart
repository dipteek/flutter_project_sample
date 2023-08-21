import 'package:nb_utils/nb_utils.dart';

class SharedPreferencesHelper {
  static Future<void> saveString(String key, String value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    await _prefs.setString(key, value);
  }

  static Future<String> getString(String key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    return await _prefs.getString(key) ?? "";
  }
}
