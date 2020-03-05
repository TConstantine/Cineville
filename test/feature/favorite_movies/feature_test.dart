import 'package:bloc/bloc.dart';
import 'package:cineville/data/datasource/database_data_source.dart';
import 'package:cineville/data/datasource/preferences_data_source.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/mapper/movie_domain_entity_mapper.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/data/repository/favorite_depository.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/repository/favorite_repository.dart';
import 'package:cineville/domain/usecase/mark_movie_as_favorite_use_case.dart';
import 'package:cineville/domain/usecase/get_favorite_movies_use_case.dart';
import 'package:cineville/domain/usecase/is_movie_marked_as_favorite_use_case.dart';
import 'package:cineville/domain/usecase/remove_movie_from_favorites_use_case.dart';
import 'package:cineville/domain/usecase/use_case_no_params.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:cineville/presentation/bloc/event/add_movie_to_favorite_list_event.dart';
import 'package:cineville/presentation/bloc/event/is_favorite_movie_event.dart';
import 'package:cineville/presentation/bloc/event/load_favorite_movies_event.dart';
import 'package:cineville/presentation/bloc/event/remove_movie_from_favorite_list_event.dart';
import 'package:cineville/presentation/bloc/favorite_list_bloc.dart';
import 'package:cineville/presentation/bloc/favorite_movie_bloc.dart';
import 'package:cineville/resources/movie_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDatabaseDataSource extends Mock implements DatabaseDataSource {}

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockLocalDateSource extends Mock implements PreferencesDataSource {}

class MockNetwork extends Mock implements Network {}

void main() {
  DatabaseDataSource mockDatabaseDataSource;
  Bloc favoriteMovieBloc;
  Bloc favoriteListBloc;

  setUp(() {
    mockDatabaseDataSource = MockDatabaseDataSource();
    final MovieDomainEntityMapper movieMapper = MovieDomainEntityMapper();
    final FavoriteRepository favoriteRepository = FavoriteDepository(
      mockDatabaseDataSource,
      movieMapper,
    );
    final UseCaseWithParams<bool, int> isFavoriteMovieUseCase =
        IsMovieMarkedAsFavoriteUseCase(favoriteRepository);
    final UseCaseWithParams<void, int> addMovieToFavoriteListUseCase =
        MarkMovieAsFavoriteUseCase(favoriteRepository);
    final UseCaseWithParams<void, int> removeMovieFromFavoriteListUseCase =
        RemoveMovieFromFavoritesUseCase(favoriteRepository);
    favoriteMovieBloc = FavoriteMovieBloc(
      isFavoriteMovieUseCase,
      addMovieToFavoriteListUseCase,
      removeMovieFromFavoriteListUseCase,
    );
    final UseCaseNoParams<List<Movie>> getFavoriteMoviesUseCase =
        GetFavoriteMoviesUseCase(favoriteRepository);
    favoriteListBloc = FavoriteListBloc(getFavoriteMoviesUseCase);
  });

  test(
      'should retrieve favorite movies from DatabaseDataSource when a LoadFavoriteMoviesEvent is triggered',
      () async {
    favoriteListBloc.dispatch(LoadFavoriteMoviesEvent());
    await untilCalled(mockDatabaseDataSource.getMovies(any));

    verify(mockDatabaseDataSource.getMovies(MovieCategory.FAVORITE));
  });

  test(
      'should check DatabaseDataSource if a movie is favorite when an IsFavoriteMovieEvent is dispatched',
      () async {
    final testMovieId = 1;
    favoriteMovieBloc.dispatch(IsFavoriteMovieEvent(testMovieId));
    await untilCalled(mockDatabaseDataSource.isMovieMarkedAsFavorite(testMovieId));

    verify(mockDatabaseDataSource.isMovieMarkedAsFavorite(testMovieId));
  });

  test('should add movie to favorite list when an AddMovieToFavoriteListEvent is dispatched',
      () async {
    final int testMovieId = 1;

    favoriteMovieBloc.dispatch(AddMovieToFavoriteListEvent(testMovieId));
    await untilCalled(mockDatabaseDataSource.markMovieAsFavorite(any));

    verify(mockDatabaseDataSource.markMovieAsFavorite(testMovieId));
  });

  test(
      'should remove movie from favorite list when a RemoveMovieFromFavoriteListEvent is dispatched',
      () async {
    final int testMovieId = 1;

    favoriteMovieBloc.dispatch(RemoveMovieFromFavoriteListEvent(testMovieId));
    await untilCalled(mockDatabaseDataSource.removeMovieFromFavorites(testMovieId));

    verify(mockDatabaseDataSource.removeMovieFromFavorites(testMovieId));
  });
}
