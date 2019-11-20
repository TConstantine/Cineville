import 'package:cineville/data/database/dao/genre_dao.dart';
import 'package:cineville/data/database/dao/movie_dao.dart';
import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/datasource/local_data_source.dart';
import 'package:cineville/data/datasource/local_date_source.dart';
import 'package:cineville/data/datasource/local_preferences.dart';
import 'package:cineville/data/datasource/moor_database.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/datasource/tmdb_api.dart';
import 'package:cineville/data/mapper/movie_mapper.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/data/network/wireless_network.dart';
import 'package:cineville/data/repository/movie_depository.dart';
import 'package:cineville/di/injector.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/domain/usecase/get_popular_movies.dart';
import 'package:cineville/domain/usecase/get_top_rated_movies.dart';
import 'package:cineville/domain/usecase/get_upcoming_movies.dart';
import 'package:cineville/presentation/bloc/movies_bloc.dart';
import 'package:cineville/resources/untranslatable_stings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await Injector().inject();
  });

  tearDown(() {
    injector.reset();
  });

  test('should register movies bloc with get popular movies use case', () {
    final MoviesBloc moviesBloc =
        injector(UntranslatableStrings.MOVIES_BLOC_WITH_GET_POPULAR_MOVIES_USE_CASE_KEY)
            as MoviesBloc;

    expect(moviesBloc, isNotNull);
  });

  test('should register movies bloc with get top rated movies use case', () {
    final MoviesBloc moviesBloc =
        injector(UntranslatableStrings.MOVIES_BLOC_WITH_GET_TOP_RATED_MOVIES_USE_CASE_KEY)
            as MoviesBloc;

    expect(moviesBloc, isNotNull);
  });

  test('should register movies bloc with get upcoming movies use case', () {
    final MoviesBloc moviesBloc =
        injector(UntranslatableStrings.MOVIES_BLOC_WITH_GET_UPCOMING_MOVIES_USE_CASE_KEY)
            as MoviesBloc;

    expect(moviesBloc, isNotNull);
  });

  test('should register get popular movies use case', () {
    final GetPopularMovies getPopularMovies =
        injector(UntranslatableStrings.GET_POPULAR_MOVIES_USE_CASE_KEY) as GetPopularMovies;

    expect(getPopularMovies, isNotNull);
  });

  test('should register get top rated movies use case', () {
    final GetTopRatedMovies getTopRatedMovies =
        injector(UntranslatableStrings.GET_TOP_RATED_MOVIES_USE_CASE_KEY) as GetTopRatedMovies;

    expect(getTopRatedMovies, isNotNull);
  });

  test('should register get upcoming movies use case', () {
    final GetUpcomingMovies getUpcomingMovies =
        injector(UntranslatableStrings.GET_UPCOMING_MOVIES_USE_CASE_KEY) as GetUpcomingMovies;

    expect(getUpcomingMovies, isNotNull);
  });

  test('should register movie depository', () {
    final MovieDepository movieDepository = injector<MovieRepository>();

    expect(movieDepository, isNotNull);
  });

  test('should register tmdb api', () {
    final TmdbApi tmdbApi = injector<RemoteDataSource>();

    expect(tmdbApi, isNotNull);
  });

  test('should register moor database', () {
    final MoorDatabase moorDatabase = injector<LocalDataSource>();

    expect(moorDatabase, isNotNull);
  });

  test('should register local preferences', () {
    final LocalPreferences localPreferences = injector<LocalDateSource>();

    expect(localPreferences, isNotNull);
  });

  test('should register wireless network', () {
    final WirelessNetwork wirelessNetwork = injector<Network>();

    expect(wirelessNetwork, isNotNull);
  });

  test('should register movie mapper', () {
    final MovieMapper movieMapper = injector<MovieMapper>();

    expect(movieMapper, isNotNull);
  });

  test('should register database', () {
    final Database database = injector<Database>();

    expect(database, isNotNull);
  });

  test('should register movie dao', () {
    final MovieDao movieDao = injector<MovieDao>();

    expect(movieDao, isNotNull);
  });

  test('should register genre dao', () {
    final GenreDao genreDao = injector<GenreDao>();

    expect(genreDao, isNotNull);
  });

  test('should register shared preferences', () {
    final SharedPreferences sharedPreferences = injector<SharedPreferences>();

    expect(sharedPreferences, isNotNull);
  });

  test('should register http client', () {
    final http.Client httpClient = injector<http.Client>();

    expect(httpClient, isNotNull);
  });

  test('should register data connection checker', () {
    final DataConnectionChecker dataConnectionChecker = injector<DataConnectionChecker>();

    expect(dataConnectionChecker, isNotNull);
  });
}
