import 'package:cineville/data/datasource/preferences_data_source.dart';
import 'package:cineville/data/datasource/shared_preferences_data_source.dart';
import 'package:cineville/resources/preference_key.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  SharedPreferences mockSharedPreferences;
  PreferencesDataSource preferencesDataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    preferencesDataSource = SharedPreferencesDataSource(mockSharedPreferences);
  });

  test('should return the cached date when one exists', () async {
    final int dataInMillis = 1000000;
    when(mockSharedPreferences.getInt(any)).thenReturn(dataInMillis);

    final int date = await preferencesDataSource.getDate(PreferenceKey.POPULAR_MOVIES);

    verify(mockSharedPreferences.getInt(PreferenceKey.POPULAR_MOVIES));
    expect(date, dataInMillis);
  });

  test('should return zero when cache is empty', () async {
    when(mockSharedPreferences.getInt(any)).thenReturn(0);

    final int date = await preferencesDataSource.getDate(PreferenceKey.POPULAR_MOVIES);

    verify(mockSharedPreferences.getInt(PreferenceKey.POPULAR_MOVIES));
    expect(date, 0);
  });

  test('should store date in shared preferences', () async {
    final int dateInMillis = 1000000;

    preferencesDataSource.storeDate(PreferenceKey.POPULAR_MOVIES, dateInMillis);

    verify(mockSharedPreferences.setInt(PreferenceKey.POPULAR_MOVIES, dateInMillis));
  });
}
