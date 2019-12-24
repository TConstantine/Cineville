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
import 'package:cineville/di/injector.dart';
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
import 'package:cineville/presentation/bloc/actors_bloc.dart';
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

  test('should register get popular movies use case', () {
    final GetPopularMovies useCase = injector(UseCaseKey.GET_POPULAR_MOVIES) as GetPopularMovies;

    expect(useCase, isNotNull);
  });

  test('should register get top rated movies use case', () {
    final GetTopRatedMovies useCase =
        injector(UseCaseKey.GET_TOP_RATED_MOVIES) as GetTopRatedMovies;

    expect(useCase, isNotNull);
  });

  test('should register get upcoming movies use case', () {
    final GetUpcomingMovies useCase = injector(UseCaseKey.GET_UPCOMING_MOVIES) as GetUpcomingMovies;

    expect(useCase, isNotNull);
  });

  test('should register get movie actors use case', () {
    final GetMovieActors useCase = injector(UseCaseKey.GET_MOVIE_ACTORS) as GetMovieActors;

    expect(useCase, isNotNull);
  });

  test('should register get movie reviews use case', () {
    final GetMovieReviews useCase = injector(UseCaseKey.GET_MOVIE_REVIEWS) as GetMovieReviews;

    expect(useCase, isNotNull);
  });

  test('should register get similar movies use case', () {
    final GetSimilarMovies useCase = injector(UseCaseKey.GET_SIMILAR_MOVIES) as GetSimilarMovies;

    expect(useCase, isNotNull);
  });

  test('should register get movie videos use case', () {
    final GetMovieVideos useCase = injector(UseCaseKey.GET_MOVIE_VIDEOS) as GetMovieVideos;

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
    final MovieMapper mapper = injector<MovieMapper>();

    expect(mapper, isNotNull);
  });

  test('should register actor mapper', () {
    final ActorMapper mapper = injector<ActorMapper>();

    expect(mapper, isNotNull);
  });

  test('should register review mapper', () {
    final ReviewMapper mapper = injector<ReviewMapper>();

    expect(mapper, isNotNull);
  });

  test('should register video mapper', () {
    final VideoMapper mapper = injector<VideoMapper>();

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
