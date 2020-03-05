import 'package:bloc/bloc.dart';
import 'package:cineville/data/datasource/database_data_source.dart';
import 'package:cineville/data/datasource/preferences_data_source.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/mapper/movie_domain_entity_mapper.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/data/repository/movie_depository.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/repository/movie_repository.dart';
import 'package:cineville/domain/usecase/get_movies_use_case.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:cineville/presentation/bloc/event/load_movies_event.dart';
import 'package:cineville/presentation/bloc/movie_list_bloc.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/resources/movie_category.dart';
import 'package:cineville/util/pair.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../builder/data_entity_builder.dart';
import '../../builder/domain_entity_builder.dart';
import '../../builder/genre_data_entity_builder.dart';
import '../../builder/movie_domain_entity_builder.dart';
import '../../builder/movie_data_entity_builder.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockDatabaseDataSource extends Mock implements DatabaseDataSource {}

class MockPreferencesDataSource extends Mock implements PreferencesDataSource {}

class MockNetwork extends Mock implements Network {}

void main() {
  DomainEntityBuilder movieDomainEntityBuilder;
  DataEntityBuilder movieEntityBuilder;
  DataEntityBuilder genreEntityBuilder;
  RemoteDataSource mockRemoteDataSource;
  DatabaseDataSource mockDatabaseDataSource;
  PreferencesDataSource mockPreferencesDataSource;
  Network mockNetwork;
  Bloc moviesBloc;

  setUp(() {
    movieDomainEntityBuilder = MovieDomainEntityBuilder();
    movieEntityBuilder = MovieDataEntityBuilder();
    genreEntityBuilder = GenreDataEntityBuilder();
    mockRemoteDataSource = MockRemoteDataSource();
    mockDatabaseDataSource = MockDatabaseDataSource();
    mockPreferencesDataSource = MockPreferencesDataSource();
    mockNetwork = MockNetwork();
    final MovieDomainEntityMapper movieDomainEntityMapper = MovieDomainEntityMapper();
    final MovieRepository movieRepository = MovieDepository(
      mockRemoteDataSource,
      mockDatabaseDataSource,
      mockPreferencesDataSource,
      mockNetwork,
      movieDomainEntityMapper,
    );
    final UseCaseWithParams<List<Movie>, Pair<String, int>> loadMoviesUseCase =
        GetMoviesUseCase(movieRepository);
    moviesBloc = MovieListBloc(loadMoviesUseCase);
  });

  test('should return popular movies from remote data source', () async {
    final List<DataEntity> movieDataEntities = movieEntityBuilder.buildList();
    final List<DataEntity> genreDataEntities = genreEntityBuilder.buildList();
    final List<Movie> movies = movieDomainEntityBuilder.buildList();
    final int page = 1;
    final int todayInMillis = DateTime.now().millisecondsSinceEpoch;
    final int yesterdayInMillis = todayInMillis - 86400000;
    when(mockPreferencesDataSource.getDate(any)).thenAnswer((_) async => yesterdayInMillis);
    when(mockDatabaseDataSource.getMovieGenres(any)).thenAnswer((_) async => genreDataEntities);
    when(mockNetwork.isConnected()).thenAnswer((_) async => true);
    when(mockRemoteDataSource.getMovies(any, any)).thenAnswer((_) async => movieDataEntities);

    moviesBloc.dispatch(LoadMoviesEvent(MovieCategory.POPULAR, page));
    await untilCalled(mockRemoteDataSource.getMovies(any, any));

    verify(mockRemoteDataSource.getMovies(MovieCategory.POPULAR, page));
    expectLater(
      moviesBloc.state,
      emitsInOrder([
        LoadingState(),
        LoadedState<List<Movie>>(movies),
      ]),
    );
  });
}
