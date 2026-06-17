import 'package:shared_preferences/shared_preferences.dart';

class PreferencesMangar {
  static final PreferencesMangar _instance = PreferencesMangar._internal();

  factory PreferencesMangar() {
    //عملته عشان تعرف تستخدم ال حاجات ال PRIVATE
    return _instance;
  }

  PreferencesMangar._internal();

  late final SharedPreferences _preferences;

  init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  String? getString(String key) {
    return _preferences.getString(key);
  }
  Future<bool> setString(String key, String value) async {
    return await _preferences.setString(key, value);
  }
  bool? getBoll(String key) {
    return _preferences.getBool(key);
  }
  setBoll(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }

  remove(String key) async {
    await _preferences.remove(key);
  }
}
  