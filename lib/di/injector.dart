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
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/domain/usecase/get_popular_movies.dart';
import 'package:cineville/domain/usecase/get_top_rated_movies.dart';
import 'package:cineville/domain/usecase/get_upcoming_movies.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:cineville/presentation/bloc/movies_bloc.dart';
import 'package:cineville/resources/untranslatable_stings.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final GetIt injector = GetIt.instance;

class Injector {
  MovieRepository _movieRepository;

  Injector withMovieRepository(MovieRepository movieRepository) {
    _movieRepository = movieRepository;
    return this;
  }

  Future inject() async {
    // Bloc
    injector.registerFactory(
      () => MoviesBloc(
          injector(UntranslatableStrings.GET_POPULAR_MOVIES_USE_CASE_KEY) as GetPopularMovies),
      instanceName: UntranslatableStrings.MOVIES_BLOC_WITH_GET_POPULAR_MOVIES_USE_CASE_KEY,
    );
    injector.registerFactory(
      () => MoviesBloc(
          injector(UntranslatableStrings.GET_TOP_RATED_MOVIES_USE_CASE_KEY) as GetTopRatedMovies),
      instanceName: UntranslatableStrings.MOVIES_BLOC_WITH_GET_TOP_RATED_MOVIES_USE_CASE_KEY,
    );
    injector.registerFactory(
      () => MoviesBloc(
          injector(UntranslatableStrings.GET_UPCOMING_MOVIES_USE_CASE_KEY) as GetUpcomingMovies),
      instanceName: UntranslatableStrings.MOVIES_BLOC_WITH_GET_UPCOMING_MOVIES_USE_CASE_KEY,
    );

    // Use Case
    injector.registerLazySingleton<UseCase>(
      () => GetPopularMovies(injector()),
      instanceName: UntranslatableStrings.GET_POPULAR_MOVIES_USE_CASE_KEY,
    );
    injector.registerLazySingleton<UseCase>(
      () => GetTopRatedMovies(injector()),
      instanceName: UntranslatableStrings.GET_TOP_RATED_MOVIES_USE_CASE_KEY,
    );
    injector.registerLazySingleton<UseCase>(
          () => GetUpcomingMovies(injector()),
      instanceName: UntranslatableStrings.GET_UPCOMING_MOVIES_USE_CASE_KEY,
    );

    // Repository
    injector.registerLazySingleton<MovieRepository>(
      () => _movieRepository == null
          ? MovieDepository(
              injector(),
              injector(),
              injector(),
              injector(),
              injector(),
            )
          : _movieRepository,
    );

    // Data Source
    injector.registerLazySingleton<RemoteDataSource>(() => TmdbApi(injector()));
    injector.registerLazySingleton<LocalDataSource>(() => MoorDatabase(injector(), injector()));
    injector.registerLazySingleton<LocalDateSource>(() => LocalPreferences(injector()));

    // Network
    injector.registerLazySingleton<Network>(() => WirelessNetwork(injector()));

    // Mapper
    injector.registerLazySingleton(() => MovieMapper());

    // Database
    injector.registerLazySingleton(() => Database());
    injector.registerLazySingleton(() => MovieDao(injector()));
    injector.registerLazySingleton(() => GenreDao(injector()));

    /** External Dependencies **/
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    injector.registerLazySingleton(() => sharedPreferences);
    injector.registerLazySingleton(() => http.Client());
    injector.registerLazySingleton(() => DataConnectionChecker());
  }
}
