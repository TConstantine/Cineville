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
import 'package:cineville/di/injector.dart';
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
import 'package:cineville/presentation/bloc/actors_bloc.dart';
import 'package:cineville/presentation/bloc/favorite_list_bloc.dart';
import 'package:cineville/presentation/bloc/favorite_movie_bloc.dart';
import 'package:cineville/presentation/bloc/movies_bloc.dart';
import 'package:cineville/presentation/bloc/reviews_bloc.dart';
import 'package:cineville/presentation/bloc/videos_bloc.dart';
import 'package:cineville/resources/use_case_key.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await Injector().inject();
  });

  tearDown(() {
    injector.reset();
  });

  test('should register movies bloc', () {
    final MoviesBloc bloc = injector<MoviesBloc>();

    expect(bloc, isNotNull);
  });

  test('should register actors bloc', () {
    final ActorsBloc bloc = injector<ActorsBloc>();

    expect(bloc, isNotNull);
  });

  test('should register reviews bloc', () {
    final ReviewsBloc bloc = injector<ReviewsBloc>();

    expect(bloc, isNotNull);
  });

  test('should register videos bloc', () {
    final VideosBloc bloc = injector<VideosBloc>();

    expect(bloc, isNotNull);
  });

  test('should register FavoriteMovieBloc', () {
    final FavoriteMovieBloc bloc = injector<FavoriteMovieBloc>();

    expect(bloc, isNotNull);
  });

  test('should register FavoriteListBloc', () {
    final FavoriteListBloc bloc = injector<FavoriteListBloc>();

    expect(bloc, isNotNull);
  });

  test('should register get popular movies use case', () {
    final GetPopularMoviesUseCase useCase = injector(UseCaseKey.GET_POPULAR_MOVIES) as GetPopularMoviesUseCase;

    expect(useCase, isNotNull);
  });

  test('should register get top rated movies use case', () {
    final GetTopRatedMoviesUseCase useCase =
        injector(UseCaseKey.GET_TOP_RATED_MOVIES) as GetTopRatedMoviesUseCase;

    expect(useCase, isNotNull);
  });

  test('should register get upcoming movies use case', () {
    final GetUpcomingMoviesUseCase useCase = injector(UseCaseKey.GET_UPCOMING_MOVIES) as GetUpcomingMoviesUseCase;

    expect(useCase, isNotNull);
  });

  test('should register get movie actors use case', () {
    final GetMovieActorsUseCase useCase = injector(UseCaseKey.GET_MOVIE_ACTORS) as GetMovieActorsUseCase;

    expect(useCase, isNotNull);
  });

  test('should register get movie reviews use case', () {
    final GetMovieReviewsUseCase useCase = injector(UseCaseKey.GET_MOVIE_REVIEWS) as GetMovieReviewsUseCase;

    expect(useCase, isNotNull);
  });

  test('should register get similar movies use case', () {
    final GetSimilarMoviesUseCase useCase = injector(UseCaseKey.GET_SIMILAR_MOVIES) as GetSimilarMoviesUseCase;

    expect(useCase, isNotNull);
  });

  test('should register get movie videos use case', () {
    final GetMovieVideosUseCase useCase = injector(UseCaseKey.GET_MOVIE_VIDEOS) as GetMovieVideosUseCase;

    expect(useCase, isNotNull);
  });

  test('should register get favorite movies use case', () {
    final GetFavoriteMoviesUseCase useCase = injector(UseCaseKey.GET_FAVORITE_MOVIES) as GetFavoriteMoviesUseCase;

    expect(useCase, isNotNull);
  });

  test('should register IsFavoriteMovieUseCase', () {
    final IsMovieMarkedAsFavoriteUseCase useCase =
        injector(UseCaseKey.IS_FAVORITE_MOVIE) as IsMovieMarkedAsFavoriteUseCase;

    expect(useCase, isNotNull);
  });

  test('should register add movie to favorite list use case', () {
    final MarkMovieAsFavoriteUseCase useCase =
        injector(UseCaseKey.ADD_MOVIE_TO_FAVORITE_LIST) as MarkMovieAsFavoriteUseCase;

    expect(useCase, isNotNull);
  });

  test('should register remove movie from favorite list use case', () {
    final RemoveMovieFromFavoritesUseCase useCase =
        injector(UseCaseKey.REMOVE_MOVIE_FROM_FAVORITE_LIST) as RemoveMovieFromFavoritesUseCase;

    expect(useCase, isNotNull);
  });

  test('should register movie depository', () {
    final MovieDepository depository = injector<MovieRepository>();

    expect(depository, isNotNull);
  });

  test('should register actor depository', () {
    final ActorDepository depository = injector<ActorRepository>();

    expect(depository, isNotNull);
  });

  test('should register review depository', () {
    final ReviewDepository depository = injector<ReviewRepository>();

    expect(depository, isNotNull);
  });

  test('should register video depository', () {
    final VideoDepository depository = injector<VideoRepository>();

    expect(depository, isNotNull);
  });

  test('should register favorite depository', () {
    final FavoriteDepository depository = injector<FavoriteRepository>();

    expect(depository, isNotNull);
  });

  test('should register tmdb api', () {
    final TmdbRemoteDataSource tmdbApi = injector<RemoteDataSource>();

    expect(tmdbApi, isNotNull);
  });

  test('should register moor database', () {
    final MoorDatabaseDataSource moorDatabase = injector<DatabaseDataSource>();

    expect(moorDatabase, isNotNull);
  });

  test('should register local preferences', () {
    final SharedPreferencesDataSource localPreferences = injector<PreferencesDataSource>();

    expect(localPreferences, isNotNull);
  });

  test('should register wireless network', () {
    final WirelessNetwork wirelessNetwork = injector<Network>();

    expect(wirelessNetwork, isNotNull);
  });

  test('should register movie mapper', () {
    final MovieDomainEntityMapper mapper = injector<MovieDomainEntityMapper>();

    expect(mapper, isNotNull);
  });

  test('should register actor mapper', () {
    final ActorDomainEntityMapper mapper = injector<ActorDomainEntityMapper>();

    expect(mapper, isNotNull);
  });

  test('should register review mapper', () {
    final ReviewDomainEntityMapper mapper = injector<ReviewDomainEntityMapper>();

    expect(mapper, isNotNull);
  });

  test('should register video mapper', () {
    final VideoDomainEntityMapper mapper = injector<VideoDomainEntityMapper>();

    expect(mapper, isNotNull);
  });

  test('should register database', () {
    final Database database = injector<Database>();

    expect(database, isNotNull);
  });

  test('should register movie dao', () {
    final MovieDao dao = injector<MovieDao>();

    expect(dao, isNotNull);
  });

  test('should register genre dao', () {
    final GenreDao dao = injector<GenreDao>();

    expect(dao, isNotNull);
  });

  test('should register actor dao', () {
    final ActorDao dao = injector<ActorDao>();

    expect(dao, isNotNull);
  });

  test('should register review dao', () {
    final ReviewDao dao = injector<ReviewDao>();

    expect(dao, isNotNull);
  });

  test('should register video dao', () {
    final VideoDao dao = injector<VideoDao>();

    expect(dao, isNotNull);
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
