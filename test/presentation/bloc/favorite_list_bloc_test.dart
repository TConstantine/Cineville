import 'package:bloc/bloc.dart';
import 'package:cineville/domain/error/failure/no_data_failure.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/usecase/use_case_no_params.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/event/load_favorite_movies_event.dart';
import 'package:cineville/presentation/bloc/favorite_list_bloc.dart';
import 'package:cineville/presentation/bloc/state/empty_state.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../builder/domain_entity_builder.dart';
import '../../builder/movie_domain_entity_builder.dart';

class MockGetFavoriteMoviesUseCase extends Mock implements UseCaseNoParams<List<Movie>> {}

void main() {
  DomainEntityBuilder movieDomainEntityBuilder;
  UseCaseNoParams<List<Movie>> mockGetFavoriteMoviesUseCase;
  Bloc favoriteListBloc;

  setUp(() {
    movieDomainEntityBuilder = MovieDomainEntityBuilder();
    mockGetFavoriteMoviesUseCase = MockGetFavoriteMoviesUseCase();
    favoriteListBloc = FavoriteListBloc(mockGetFavoriteMoviesUseCase);
  });

  test('should emit EmptyState when returning initial state', () {
    expect(favoriteListBloc.initialState, equals(EmptyState()));
  });

  test(
      'should emit [EmptyState, LoadingState, LoadedState] when a LoadFavoriteMoviesEvent is triggered and completed successfully',
      () async {
    final List<Movie> testFavoriteMovies = movieDomainEntityBuilder.buildList();
    when(mockGetFavoriteMoviesUseCase.execute()).thenAnswer((_) async => Right(testFavoriteMovies));

    final List<BlocState> emittedStates = [
      EmptyState(),
      LoadingState(),
      LoadedState<List<Movie>>(testFavoriteMovies),
    ];
    expectLater(favoriteListBloc.state, emitsInOrder(emittedStates));

    favoriteListBloc.dispatch(LoadFavoriteMoviesEvent());
  });

  test(
      'should emit [EmptyState, LoadingState, ErrorState] when a LoadFavoriteMoviesEvent is triggered and completed unsuccessfully',
      () async {
    when(mockGetFavoriteMoviesUseCase.execute()).thenAnswer((_) async => Left(NoDataFailure()));

    final List<BlocState> emittedStates = [
      EmptyState(),
      LoadingState(),
      ErrorState(TranslatableStrings.NO_FAVORITE_MOVIES),
    ];
    expectLater(favoriteListBloc.state, emitsInOrder(emittedStates));

    favoriteListBloc.dispatch(LoadFavoriteMoviesEvent());
  });
}
