import 'package:shared_preferences/shared_preferences.dart';

class AppLocalStorage {
  static Future<SharedPreferences> pref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  static void addToPref(key, value) async {
    final SharedPreferences prefs = await pref();
    await prefs.setString('$key', '$value');
  }

  static getdata(key) async {
    final SharedPreferences prefs = await pref();
    final String? data = prefs.getString('$key');

    return data;
  }
}
