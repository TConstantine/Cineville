import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:popular_movies/data/database/dao/genre_dao.dart';
import 'package:popular_movies/data/database/dao/movie_dao.dart';
import 'package:popular_movies/data/database/database.dart';
import 'package:popular_movies/data/datasource/local_data_source.dart';
import 'package:popular_movies/data/datasource/local_date_source.dart';
import 'package:popular_movies/data/datasource/local_preferences.dart';
import 'package:popular_movies/data/datasource/moor_database.dart';
import 'package:popular_movies/data/datasource/remote_data_source.dart';
import 'package:popular_movies/data/datasource/tmdb_api.dart';
import 'package:popular_movies/data/mapper/movie_mapper.dart';
import 'package:popular_movies/data/network/network.dart';
import 'package:popular_movies/data/network/wireless_network.dart';
import 'package:popular_movies/data/repository/movie_depository.dart';
import 'package:popular_movies/domain/repository/movie_repository.dart';
import 'package:popular_movies/domain/usecase/get_popular_movies.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/popular_movies_bloc.dart';
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
    injector.registerFactory(() => PopularMoviesBloc(injector()));

    // Use Case
    injector.registerLazySingleton(
        () => GetPopularMovies(injector()));

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
