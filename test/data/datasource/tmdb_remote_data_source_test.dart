import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/datasource/tmdb_remote_data_source.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/data_entity_type.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/data/network/tmdb_api_constant.dart';
import 'package:cineville/data/network/tmdb_api_key.dart';
import 'package:cineville/resources/movie_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';

import '../../builder/actor_data_entity_builder.dart';
import '../../builder/data_entity_builder.dart';
import '../../builder/genre_data_entity_builder.dart';
import '../../builder/movie_data_entity_builder.dart';
import '../../builder/review_data_entity_builder.dart';
import '../../builder/video_data_entity_builder.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  DataEntityBuilder movieDataEntityBuilder;
  DataEntityBuilder genreDataEntityBuilder;
  MockHttpClient mockHttpClient;
  RemoteDataSource remoteDataSource;

  setUp(() {
    movieDataEntityBuilder = MovieDataEntityBuilder();
    genreDataEntityBuilder = GenreDataEntityBuilder();
    mockHttpClient = MockHttpClient();
    remoteDataSource = TmdbRemoteDataSource(mockHttpClient);
  });

  group('getMovieDataEntities', () {
    final int movieId = 1;
    final int page = 1;
    final DataEntityBuilder actorDataEntityBuilder = ActorDataEntityBuilder();
    final DataEntityBuilder reviewDataEntityBuilder = ReviewDataEntityBuilder();
    final DataEntityBuilder movieDataEntityBuilder = MovieDataEntityBuilder();
    final DataEntityBuilder videoDataEntityBuilder = VideoDataEntityBuilder();

    void getMovieDataEntities(
      String dataEntityType,
      DataEntityBuilder dataEntityBuilder,
      String endpoint,
    ) {
      test('should return $dataEntityType entities from $dataEntityType endpoint', () async {
        final int movieId = 1;
        final String dataEntitiesAsJsonString = dataEntityBuilder.buildListAsJsonString();
        final List<DataEntity> dataEntityList = dataEntityBuilder.buildList();
        when(mockHttpClient.get(any))
            .thenAnswer((_) async => http.Response(dataEntitiesAsJsonString, 200));

        final List<DataEntity> dataEntities =
            await remoteDataSource.getMovieDataEntities(dataEntityType, movieId);

        verify(mockHttpClient.get('$endpoint'));
        expect(dataEntities, dataEntityList);
      });
    }

    void throwException(String dataEntityType) {
      test(
          'should throw server exception when request for $dataEntityType entities has empty response body',
          () {
        when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('', 404));

        final Function call = remoteDataSource.getMovieDataEntities;

        expect(() => call(dataEntityType, movieId), throwsA(TypeMatcher<ServerException>()));
      });
    }

    getMovieDataEntities(
      DataEntityType.ACTOR,
      actorDataEntityBuilder,
      '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE}$movieId${TmdbApiConstant.ACTORS_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY',
    );
    getMovieDataEntities(
      DataEntityType.REVIEW,
      reviewDataEntityBuilder,
      '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE}$movieId${TmdbApiConstant.REVIEWS_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY',
    );
    getMovieDataEntities(
      DataEntityType.SIMILAR_MOVIE,
      movieDataEntityBuilder,
      '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE}$movieId${TmdbApiConstant.SIMILAR_MOVIES_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY&${TmdbApiConstant.PAGE_QUERY}$page',
    );
    getMovieDataEntities(
      DataEntityType.VIDEO,
      videoDataEntityBuilder,
      '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE}$movieId${TmdbApiConstant.VIDEOS_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY',
    );
    throwException(DataEntityType.ACTOR);
    throwException(DataEntityType.REVIEW);
    throwException(DataEntityType.SIMILAR_MOVIE);
    throwException(DataEntityType.VIDEO);
  });

  test('should return genres from genres endpoint', () async {
    final String genreDataEntitiesAsJson = genreDataEntityBuilder.buildListAsJsonString();
    final List<DataEntity> genreDataEntityList = genreDataEntityBuilder.buildList();
    when(mockHttpClient.get(any))
        .thenAnswer((_) async => http.Response(genreDataEntitiesAsJson, 200));

    final List<DataEntity> genreDataEntities = await remoteDataSource.getMovieGenres();

    verify(mockHttpClient.get(
        '${TmdbApiConstant.BASE_URL}${TmdbApiConstant.MOVIE_GENRES_ENDPOINT}?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY'));
    expect(genreDataEntities, genreDataEntityList);
  });

  test('should throw server exception when request for genres has empty response body', () {
    when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('', 404));

    final Function call = remoteDataSource.getMovieGenres;

    expect(() => call(), throwsA(TypeMatcher<ServerException>()));
  });

  group('getMovies', () {
    void getMovies(String movieCategory, String endpoint) {
      test('should return $movieCategory movies from $movieCategory movies endpoint', () async {
        final int page = 1;
        final String movieDataEntitiesAsJsonString = movieDataEntityBuilder.buildListAsJsonString();
        final List<DataEntity> movieDataEntityList = movieDataEntityBuilder.buildList();
        when(mockHttpClient.get(any))
            .thenAnswer((_) async => http.Response(movieDataEntitiesAsJsonString, 200));

        final List<DataEntity> movieDataEntities =
            await remoteDataSource.getMovies(movieCategory, page);

        verify(mockHttpClient.get(
            '${TmdbApiConstant.BASE_URL}$endpoint?${TmdbApiConstant.API_KEY_QUERY}$TMDB_API_KEY&${TmdbApiConstant.PAGE_QUERY}$page'));
        expect(movieDataEntities, movieDataEntityList);
      });
    }

    void throwException(String movieCategory) {
      test(
          'should throw server exception when request for $movieCategory movies has empty response body',
          () {
        final int page = 1;
        when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('', 404));

        final Function call = remoteDataSource.getMovies;

        expect(() => call(movieCategory, page), throwsA(TypeMatcher<ServerException>()));
      });
    }

    getMovies(MovieCategory.POPULAR, TmdbApiConstant.POPULAR_MOVIES_ENDPOINT);
    getMovies(MovieCategory.TOP_RATED, TmdbApiConstant.TOP_RATED_MOVIES_ENDPOINT);
    getMovies(MovieCategory.UPCOMING, TmdbApiConstant.UPCOMING_MOVIES_ENDPOINT);
    throwException(MovieCategory.POPULAR);
    throwException(MovieCategory.TOP_RATED);
    throwException(MovieCategory.UPCOMING);
  });
}
