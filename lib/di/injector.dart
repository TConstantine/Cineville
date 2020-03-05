import 'package:cineville/data/database/dao/actor_dao.dart';
import 'package:cineville/data/database/dao/genre_dao.dart';
import 'package:cineville/data/database/dao/movie_dao.dart';
import 'package:cineville/data/database/dao/review_dao.dart';
import 'package:cineville/data/database/dao/video_dao.dart';
import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/datasource/database_data_source.dart';
import 'package:cineville/data/datasource/preferences_data_source.dart';
import 'package:cineville/data/datasource/shared_preferences_data_source.dart';
import 'package:cineville/data/datasource/moor_database_data_source.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/datasource/tmdb_remote_data_source.dart';
import 'package:cineville/data/mapper/actor_domain_entity_mapper.dart';
import 'package:cineville/data/mapper/movie_domain_entity_mapper.dart';
import 'package:cineville/data/mapper/review_domain_entity_mapper.dart';
import 'package:cineville/data/mapper/video_domain_entity_mapper.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/data/network/wireless_network.dart';
import 'package:cineville/data/repository/actor_depository.dart';
import 'package:cineville/data/repository/favorite_depository.dart';
import 'package:cineville/data/repository/movie_depository.dart';
import 'package:cineville/data/repository/review_depository.dart';
import 'package:cineville/data/repository/video_depository.dart';
import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/entity/review.dart';
import 'package:cineville/domain/entity/video.dart';
import 'package:cineville/domain/repository/actor_repository.dart';
import 'package:cineville/domain/repository/favorite_repository.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/domain/repository/review_repository.dart';
import 'package:cineville/domain/repository/video_repository.dart';
import 'package:cineville/domain/usecase/mark_movie_as_favorite_use_case.dart';
import 'package:cineville/domain/usecase/get_favorite_movies_use_case.dart';
import 'package:cineville/domain/usecase/get_movie_actors_use_case.dart';
import 'package:cineville/domain/usecase/get_movie_reviews_use_case.dart';
import 'package:cineville/domain/usecase/get_movie_videos_use_case.dart';
import 'package:cineville/domain/usecase/get_popular_movies_use_case.dart';
import 'package:cineville/domain/usecase/get_similar_movies_use_case.dart';
import 'package:cineville/domain/usecase/get_top_rated_movies_use_case.dart';
import 'package:cineville/domain/usecase/get_upcoming_movies_use_case.dart';
import 'package:cineville/domain/usecase/is_movie_marked_as_favorite_use_case.dart';
import 'package:cineville/domain/usecase/remove_movie_from_favorites_use_case.dart';
import 'package:cineville/domain/usecase/use_case_no_params.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:cineville/presentation/bloc/actors_bloc.dart';
import 'package:cineville/presentation/bloc/favorite_list_bloc.dart';
import 'package:cineville/presentation/bloc/favorite_movie_bloc.dart';
import 'package:cineville/presentation/bloc/movies_bloc.dart';
import 'package:cineville/presentation/bloc/reviews_bloc.dart';
import 'package:cineville/presentation/bloc/videos_bloc.dart';
import 'package:cineville/resources/use_case_key.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:moor_flutter/moor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt injector = GetIt.instance;

class Injector {
  MoviesBloc _moviesBloc;
  ActorsBloc _actorsBloc;
  FavoriteMovieBloc _favoriteMovieBloc;
  FavoriteListBloc _favoriteListBloc;
  RemoteDataSource _remoteDataSource;

  Injector withMoviesBloc(MoviesBloc bloc) {
    _moviesBloc = bloc;
    return this;
  }

  Injector withActorsBloc(ActorsBloc bloc) {
    _actorsBloc = bloc;
    return this;
  }

  Injector withFavoriteMovieBloc(FavoriteMovieBloc bloc) {
    _favoriteMovieBloc = bloc;
    return this;
  }

  Injector withFavoriteListBloc(FavoriteListBloc bloc) {
    _favoriteListBloc = bloc;
    return this;
  }

  Injector withRemoteDataSource(RemoteDataSource dataSource) {
    _remoteDataSource = dataSource;
    return this;
  }

  Future inject() async {
    // Blocs
    injector.registerFactory(
      () => _moviesBloc == null
          ? MoviesBloc(
              injector(UseCaseKey.GET_POPULAR_MOVIES) as GetPopularMoviesUseCase,
              injector(UseCaseKey.GET_UPCOMING_MOVIES) as GetUpcomingMoviesUseCase,
              injector(UseCaseKey.GET_TOP_RATED_MOVIES) as GetTopRatedMoviesUseCase,
              injector(UseCaseKey.GET_SIMILAR_MOVIES) as GetSimilarMoviesUseCase)
          : _moviesBloc,
    );
    injector.registerFactory(
      () => _actorsBloc == null
          ? ActorsBloc(injector(UseCaseKey.GET_MOVIE_ACTORS) as GetMovieActorsUseCase)
          : _actorsBloc,
    );
    injector.registerFactory(
      () => ReviewsBloc(injector(UseCaseKey.GET_MOVIE_REVIEWS) as GetMovieReviewsUseCase),
    );
    injector.registerFactory(
      () => VideosBloc(injector(UseCaseKey.GET_MOVIE_VIDEOS) as GetMovieVideosUseCase),
    );
    injector.registerFactory(
      () => _favoriteMovieBloc == null
          ? FavoriteMovieBloc(
              injector(UseCaseKey.IS_FAVORITE_MOVIE) as IsMovieMarkedAsFavoriteUseCase,
              injector(UseCaseKey.ADD_MOVIE_TO_FAVORITE_LIST) as MarkMovieAsFavoriteUseCase,
              injector(UseCaseKey.REMOVE_MOVIE_FROM_FAVORITE_LIST) as RemoveMovieFromFavoritesUseCase)
          : _favoriteMovieBloc,
    );
    injector.registerFactory(
      () => _favoriteListBloc == null
          ? FavoriteListBloc(injector(UseCaseKey.GET_FAVORITE_MOVIES) as GetFavoriteMoviesUseCase)
          : _favoriteListBloc,
    );

    // Use Cases
    injector.registerLazySingleton<UseCaseWithParams<List<Movie>, int>>(
      () => GetPopularMoviesUseCase(injector()),
      instanceName: UseCaseKey.GET_POPULAR_MOVIES,
    );
    injector.registerLazySingleton<UseCaseWithParams<List<Movie>, int>>(
      () => GetUpcomingMoviesUseCase(injector()),
      instanceName: UseCaseKey.GET_UPCOMING_MOVIES,
    );
    injector.registerLazySingleton<UseCaseWithParams<List<Movie>, int>>(
      () => GetTopRatedMoviesUseCase(injector()),
      instanceName: UseCaseKey.GET_TOP_RATED_MOVIES,
    );
    injector.registerLazySingleton<UseCaseWithParams<List<Actor>, int>>(
      () => GetMovieActorsUseCase(injector()),
      instanceName: UseCaseKey.GET_MOVIE_ACTORS,
    );
    injector.registerLazySingleton<UseCaseWithParams<List<Review>, int>>(
      () => GetMovieReviewsUseCase(injector()),
      instanceName: UseCaseKey.GET_MOVIE_REVIEWS,
    );
    injector.registerLazySingleton<UseCaseWithParams<List<Movie>, int>>(
      () => GetSimilarMoviesUseCase(injector()),
      instanceName: UseCaseKey.GET_SIMILAR_MOVIES,
    );
    injector.registerLazySingleton<UseCaseWithParams<List<Video>, int>>(
      () => GetMovieVideosUseCase(injector()),
      instanceName: UseCaseKey.GET_MOVIE_VIDEOS,
    );
    injector.registerLazySingleton<UseCaseNoParams<List<Movie>>>(
      () => GetFavoriteMoviesUseCase(injector()),
      instanceName: UseCaseKey.GET_FAVORITE_MOVIES,
    );
    injector.registerLazySingleton<UseCaseWithParams<bool, int>>(
      () => IsMovieMarkedAsFavoriteUseCase(injector()),
      instanceName: UseCaseKey.IS_FAVORITE_MOVIE,
    );
    injector.registerLazySingleton<UseCaseWithParams<void, int>>(
      () => MarkMovieAsFavoriteUseCase(injector()),
      instanceName: UseCaseKey.ADD_MOVIE_TO_FAVORITE_LIST,
    );
    injector.registerLazySingleton<UseCaseWithParams<void, int>>(
      () => RemoveMovieFromFavoritesUseCase(injector()),
      instanceName: UseCaseKey.REMOVE_MOVIE_FROM_FAVORITE_LIST,
    );

    // Repositories
    injector.registerLazySingleton<MovieRepository>(
      () => MovieDepository(
        injector(),
        injector(),
        injector(),
        injector(),
        injector(),
      ),
    );
    injector.registerLazySingleton<ActorRepository>(
      () => ActorDepository(
        injector(),
        injector(),
        injector(),
        injector(),
      ),
    );
    injector.registerLazySingleton<ReviewRepository>(
      () => ReviewDepository(
        injector(),
        injector(),
        injector(),
        injector(),
      ),
    );
    injector.registerLazySingleton<VideoRepository>(
      () => VideoDepository(
        injector(),
        injector(),
        injector(),
        injector(),
      ),
    );

    injector.registerLazySingleton<FavoriteRepository>(
      () => FavoriteDepository(
        injector(),
        injector(),
      ),
    );

    // Data Sources
    injector.registerLazySingleton<RemoteDataSource>(
      () => _remoteDataSource == null ? TmdbRemoteDataSource(injector()) : _remoteDataSource,
    );
    injector.registerLazySingleton<DatabaseDataSource>(
        () => MoorDatabaseDataSource(injector(), injector(), injector(), injector(), injector()));
    injector.registerLazySingleton<PreferencesDataSource>(() => SharedPreferencesDataSource(injector()));

    // Network
    injector.registerLazySingleton<Network>(() => WirelessNetwork(injector()));

    // Mapper
    injector.registerLazySingleton(() => MovieDomainEntityMapper());
    injector.registerLazySingleton(() => ActorDomainEntityMapper());
    injector.registerLazySingleton(() => ReviewDomainEntityMapper());
    injector.registerLazySingleton(() => VideoDomainEntityMapper());

    // Database
    injector.registerLazySingleton(
        () => Database(FlutterQueryExecutor.inDatabaseFolder(path: 'db.sqlite')));
    injector.registerLazySingleton(() => MovieDao(injector()));
    injector.registerLazySingleton(() => GenreDao(injector()));
    injector.registerLazySingleton(() => ActorDao(injector()));
    injector.registerLazySingleton(() => ReviewDao(injector()));
    injector.registerLazySingleton(() => VideoDao(injector()));

    /** External Dependencies **/
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    injector.registerLazySingleton(() => sharedPreferences);
    injector.registerLazySingleton(() => http.Client());
    injector.registerLazySingleton(() => DataConnectionChecker());
  }
}
