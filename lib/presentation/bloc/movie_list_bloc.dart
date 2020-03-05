import 'package:bloc/bloc.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:cineville/presentation/bloc/bloc_event.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/event/load_movies_event.dart';
import 'package:cineville/presentation/bloc/state/empty_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/util/pair.dart';
import 'package:dartz/dartz.dart';

class MovieListBloc extends Bloc<BlocEvent, BlocState> {
  final UseCaseWithParams<List<Movie>, Pair<String, int>> _loadMoviesUseCase;

  MovieListBloc(this._loadMoviesUseCase);

  @override
  BlocState get initialState => EmptyState();

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    yield LoadingState();
    if (event is LoadMoviesEvent) {
      final Pair<String, int> useCaseParams = Pair(event.movieCategory, event.page);
      final Either<Failure, List<Movie>> useCaseResult =
          await _loadMoviesUseCase.execute(useCaseParams);
      yield useCaseResult.fold(
        (failure) => throw UnimplementedError("MovieListBloc.mapEventToState - Failure"),
        (success) => LoadedState<List<Movie>>(success),
      );
    }
  }
}
