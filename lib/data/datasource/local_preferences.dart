import 'package:cineville/data/datasource/local_date_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferences implements LocalDateSource {
  final SharedPreferences sharedPreferences;

  LocalPreferences(this.sharedPreferences);

  @override
  Future<int> getDate(String key) {
    final int date = sharedPreferences.getInt(key);
    return Future.value(date != null ? date : 0);
  }

  @override
  Future storeDate(String key, int dateInMillis) {
    return sharedPreferences.setInt(key, dateInMillis);
  }
}
