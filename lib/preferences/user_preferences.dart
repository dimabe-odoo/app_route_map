import 'package:shared_preferences/shared_preferences.dart';

class UserPreference {
  static final _instance = new UserPreference._internal();

  factory UserPreference() {
    return _instance;
  }

  UserPreference._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  get token => _prefs.getString('api-token');

  set token(String value) => _prefs.setString('api-token', value);

  get driver => _prefs.getInt('driver');

  set driver(int value) => _prefs.setInt('driver', value);

  get name => _prefs.getString('name');

  set name(String value) => _prefs.setString('name', value);

  get email => _prefs.getString('email');

  set email(String value) => _prefs.setString('email', value);

  void clearSession() {
    _prefs.clear();
  }
}
