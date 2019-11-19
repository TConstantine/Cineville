import 'package:cineville/data/datasource/local_date_source.dart';
import 'package:cineville/data/datasource/local_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  SharedPreferences _mockSharedPreferences;
  LocalDateSource _localDateSource;

  setUp(() {
    _mockSharedPreferences = MockSharedPreferences();
    _localDateSource = LocalPreferences(_mockSharedPreferences);
  });

  final int testDateInMillis = 1000000;

  group('getDate', () {
    test('should return the cached date when one exists', () async {
      when(_mockSharedPreferences.getInt(any)).thenReturn(testDateInMillis);

      final int date = await _localDateSource.getDate();

      verify(_mockSharedPreferences.getInt(LocalPreferences.DATE_KEY));
      expect(date, equals(testDateInMillis));
    });

    test('should return zero when cache is empty', () async {
      when(_mockSharedPreferences.getInt(any)).thenReturn(0);

      final int date = await _localDateSource.getDate();

      verify(_mockSharedPreferences.getInt(LocalPreferences.DATE_KEY));
      expect(date, equals(0));
    });
  });

  group('storeDate', () {
    test('should store date in shared preferences', () async {
      _localDateSource.storeDate(testDateInMillis);

      verify(_mockSharedPreferences.setInt(LocalPreferences.DATE_KEY, testDateInMillis));
    });
  });
}
