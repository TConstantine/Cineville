import 'package:cineville/data/datasource/local_date_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferences implements LocalDateSource {
  static const String DATE_KEY = 'DATE';
  final SharedPreferences _sharedPreferences;

  LocalPreferences(this._sharedPreferences);

  @override
  Future<int> getDate() {
    final int date = _sharedPreferences.getInt(DATE_KEY);
    return Future.value(date != null ? date : 0);
  }

  @override
  Future storeDate(int dateInMillis) {
    return _sharedPreferences.setInt(DATE_KEY, dateInMillis);
  }
}
