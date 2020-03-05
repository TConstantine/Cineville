import 'package:bloc/bloc.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:cineville/presentation/bloc/event/load_movies_event.dart';
import 'package:cineville/presentation/bloc/movie_list_bloc.dart';
import 'package:cineville/presentation/bloc/state/empty_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/resources/movie_category.dart';
import 'package:cineville/util/pair.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../builder/domain_entity_builder.dart';
import '../../builder/movie_domain_entity_builder.dart';

class MockLoadMoviesUseCase extends Mock
    implements UseCaseWithParams<List<Movie>, Pair<String, int>> {}

void main() {
  DomainEntityBuilder movieDomainEntityBuilder;
  UseCaseWithParams<List<Movie>, Pair<String, int>> mockLoadMoviesUseCase;
  Bloc moviesBloc;

  setUp(() {
    movieDomainEntityBuilder = MovieDomainEntityBuilder();
    mockLoadMoviesUseCase = MockLoadMoviesUseCase();
    moviesBloc = MovieListBloc(mockLoadMoviesUseCase);
  });

  test('should be at EmptyState initially', () {
    expect(moviesBloc.state, emitsInOrder([EmptyState()]));
  });

  test('should emit [LoadingState, LoadedState] when LoadMoviesEvent is dispatched', () async {
    final int page = 1;
    final Pair<String, int> useCaseParams = Pair(MovieCategory.POPULAR, page);
    final List<Movie> movies = movieDomainEntityBuilder.buildList();
    when(mockLoadMoviesUseCase.execute(any)).thenAnswer((_) async => Right(movies));

    moviesBloc.dispatch(LoadMoviesEvent(MovieCategory.POPULAR, page));
    await untilCalled(mockLoadMoviesUseCase.execute(any));

    verify(mockLoadMoviesUseCase.execute(useCaseParams));
    expectLater(
      moviesBloc.state,
      emitsInOrder([
        LoadingState(),
        LoadedState<List<Movie>>(movies),
      ]),
    );
  });
}
