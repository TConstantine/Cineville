abstract class LocalDateSource {
  Future<int> getDate();
  Future storeDate(int dateInMillis);
}
