import 'package:cineville/data/database/dao/actor_dao.dart';
import 'package:cineville/data/database/dao/genre_dao.dart';
import 'package:cineville/data/database/dao/movie_dao.dart';
import 'package:cineville/data/database/dao/review_dao.dart';
import 'package:cineville/data/database/dao/video_dao.dart';
import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/datasource/local_data_source.dart';
import 'package:cineville/data/datasource/local_date_source.dart';
import 'package:cineville/data/datasource/local_preferences.dart';
import 'package:cineville/data/datasource/moor_database.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/datasource/tmdb_api.dart';
import 'package:cineville/data/mapper/actor_mapper.dart';
import 'package:cineville/data/mapper/movie_mapper.dart';
import 'package:cineville/data/mapper/review_mapper.dart';
import 'package:cineville/data/mapper/video_mapper.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/data/network/wireless_network.dart';
import 'package:cineville/data/repository/actor_depository.dart';
import 'package:cineville/data/repository/movie_depository.dart';
import 'package:cineville/data/repository/review_depository.dart';
import 'package:cineville/data/repository/video_depository.dart';
import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/entity/review.dart';
import 'package:cineville/domain/entity/video.dart';
import 'package:cineville/domain/repository/actor_repository.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/domain/repository/review_repository.dart';
import 'package:cineville/domain/repository/video_repository.dart';
import 'package:cineville/domain/usecase/get_movie_actors.dart';
import 'package:cineville/domain/usecase/get_movie_reviews.dart';
import 'package:cineville/domain/usecase/get_movie_videos.dart';
import 'package:cineville/domain/usecase/get_popular_movies.dart';
import 'package:cineville/domain/usecase/get_similar_movies.dart';
import 'package:cineville/domain/usecase/get_top_rated_movies.dart';
import 'package:cineville/domain/usecase/get_upcoming_movies.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:cineville/presentation/bloc/actors_bloc.dart';
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
  MovieRepository _movieRepository;
  ActorRepository _actorRepository;
  ReviewRepository _reviewRepository;
  VideoRepository _videoRepository;

  Injector withMovieRepository(MovieRepository repository) {
    _movieRepository = repository;
    return this;
  }

  Injector withActorRepository(ActorRepository repository) {
    _actorRepository = repository;
    return this;
  }

  Injector withReviewRepository(ReviewRepository repository) {
    _reviewRepository = repository;
    return this;
  }

  Injector withVideoRepository(VideoRepository repository) {
    _videoRepository = repository;
    return this;
  }

  Future inject() async {
    // Bloc
    injector.registerFactory(
      () => MoviesBloc(
          injector(UseCaseKey.GET_POPULAR_MOVIES) as GetPopularMovies,
          injector(UseCaseKey.GET_UPCOMING_MOVIES) as GetUpcomingMovies,
          injector(UseCaseKey.GET_TOP_RATED_MOVIES) as GetTopRatedMovies,
          injector(UseCaseKey.GET_SIMILAR_MOVIES) as GetSimilarMovies),
    );
    injector.registerFactory(
      () => ActorsBloc(injector(UseCaseKey.GET_MOVIE_ACTORS) as GetMovieActors),
    );
    injector.registerFactory(
      () => ReviewsBloc(injector(UseCaseKey.GET_MOVIE_REVIEWS) as GetMovieReviews),
    );
    injector.registerFactory(
      () => VideosBloc(injector(UseCaseKey.GET_MOVIE_VIDEOS) as GetMovieVideos),
    );

    // Use Case
    injector.registerLazySingleton<UseCase<Movie>>(
      () => GetPopularMovies(injector()),
      instanceName: UseCaseKey.GET_POPULAR_MOVIES,
    );
    injector.registerLazySingleton<UseCase<Movie>>(
      () => GetUpcomingMovies(injector()),
      instanceName: UseCaseKey.GET_UPCOMING_MOVIES,
    );
    injector.registerLazySingleton<UseCase<Movie>>(
      () => GetTopRatedMovies(injector()),
      instanceName: UseCaseKey.GET_TOP_RATED_MOVIES,
    );
    injector.registerLazySingleton<UseCase<Actor>>(
      () => GetMovieActors(injector()),
      instanceName: UseCaseKey.GET_MOVIE_ACTORS,
    );
    injector.registerLazySingleton<UseCase<Review>>(
      () => GetMovieReviews(injector()),
      instanceName: UseCaseKey.GET_MOVIE_REVIEWS,
    );
    injector.registerLazySingleton<UseCase<Movie>>(
      () => GetSimilarMovies(injector()),
      instanceName: UseCaseKey.GET_SIMILAR_MOVIES,
    );
    injector.registerLazySingleton<UseCase<Video>>(
      () => GetMovieVideos(injector()),
      instanceName: UseCaseKey.GET_MOVIE_VIDEOS,
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
    injector.registerLazySingleton<ActorRepository>(
      () => _actorRepository == null
          ? ActorDepository(
              injector(),
              injector(),
              injector(),
              injector(),
            )
          : _actorRepository,
    );
    injector.registerLazySingleton<ReviewRepository>(
      () => _reviewRepository == null
          ? ReviewDepository(
              injector(),
              injector(),
              injector(),
              injector(),
            )
          : _reviewRepository,
    );
    injector.registerLazySingleton<VideoRepository>(
      () => _videoRepository == null
          ? VideoDepository(
              injector(),
              injector(),
              injector(),
              injector(),
            )
          : _videoRepository,
    );

    // Data Source
    injector.registerLazySingleton<RemoteDataSource>(() => TmdbApi(injector()));
    injector.registerLazySingleton<LocalDataSource>(
        () => MoorDatabase(injector(), injector(), injector(), injector(), injector()));
    injector.registerLazySingleton<LocalDateSource>(() => LocalPreferences(injector()));

    // Network
    injector.registerLazySingleton<Network>(() => WirelessNetwork(injector()));

    // Mapper
    injector.registerLazySingleton(() => MovieMapper());
    injector.registerLazySingleton(() => ActorMapper());
    injector.registerLazySingleton(() => ReviewMapper());
    injector.registerLazySingleton(() => VideoMapper());

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
