import 'package:cineville/data/datasource/preferences_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDataSource implements PreferencesDataSource {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesDataSource(this._sharedPreferences);

  @override
  Future<int> getDate(String key) {
    final int date = _sharedPreferences.getInt(key);
    return Future.value(date != null ? date : 0);
  }

  @override
  Future storeDate(String key, int dateInMillis) {
    return _sharedPreferences.setInt(key, dateInMillis);
  }
}
