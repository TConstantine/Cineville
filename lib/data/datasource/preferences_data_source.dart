abstract class PreferencesDataSource {
  Future<int> getDate(String key);
  Future storeDate(String key, int dateInMillis);
}
