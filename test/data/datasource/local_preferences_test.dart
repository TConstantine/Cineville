import 'package:cineville/data/datasource/local_date_source.dart';
import 'package:cineville/data/datasource/local_preferences.dart';
import 'package:cineville/resources/preference_key.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  SharedPreferences mockSharedPreferences;
  LocalDateSource localDateSource;

  setUpAll(() {
    mockSharedPreferences = MockSharedPreferences();
  });

  setUp(() {
    localDateSource = LocalPreferences(mockSharedPreferences);
  });

  final int testDateInMillis = 1000000;

  group('getDate', () {
    test('should return the cached date when one exists', () async {
      when(mockSharedPreferences.getInt(any)).thenReturn(testDateInMillis);

      final int date = await localDateSource.getDate(PreferenceKey.POPULAR_MOVIES);

      verify(mockSharedPreferences.getInt(PreferenceKey.POPULAR_MOVIES));
      expect(date, equals(testDateInMillis));
    });

    test('should return zero when cache is empty', () async {
      when(mockSharedPreferences.getInt(any)).thenReturn(0);

      final int date = await localDateSource.getDate(PreferenceKey.POPULAR_MOVIES);

      verify(mockSharedPreferences.getInt(PreferenceKey.POPULAR_MOVIES));
      expect(date, equals(0));
    });
  });

  group('storeDate', () {
    test('should store date in shared preferences', () async {
      localDateSource.storeDate(PreferenceKey.POPULAR_MOVIES, testDateInMillis);

      verify(mockSharedPreferences.setInt(PreferenceKey.POPULAR_MOVIES, testDateInMillis));
    });
  });
}
