import 'package:bloc/bloc.dart';
import 'package:cineville/data/error/failure/network_failure.dart';
import 'package:cineville/data/error/failure/server_failure.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:cineville/presentation/bloc/event/load_movies_event.dart';
import 'package:cineville/presentation/bloc/movies_event.dart';
import 'package:cineville/presentation/bloc/movies_state.dart';
import 'package:cineville/presentation/bloc/state/empty_state.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:dartz/dartz.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final UseCase _getMoviesUseCase;

  MoviesBloc(this._getMoviesUseCase);

  @override
  MoviesState get initialState => EmptyState();

  @override
  Stream<MoviesState> mapEventToState(MoviesEvent event) async* {
    if (event is LoadMoviesEvent) {
      yield LoadingState();
      final Either<Failure, List<Movie>> useCaseResult =
          await _getMoviesUseCase.execute(event.page);
      yield useCaseResult.fold(
        (failure) => ErrorState(_mapFailureToMessage(failure)),
        (movies) => LoadedState(movies),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return TranslatableStrings.SERVER_FAILURE_MESSAGE;
      case NetworkFailure:
        return TranslatableStrings.NETWORK_FAILURE_MESSAGE;
      default:
        return TranslatableStrings.UNEXPECTED_FAILURE_MESSAGE;
    }
  }
}
