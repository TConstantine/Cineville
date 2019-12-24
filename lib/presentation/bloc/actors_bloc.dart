import 'package:bloc/bloc.dart';
import 'package:cineville/data/error/failure/network_failure.dart';
import 'package:cineville/data/error/failure/no_data_failure.dart';
import 'package:cineville/data/error/failure/server_failure.dart';
import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:cineville/presentation/bloc/bloc_event.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/event/load_movie_actors_event.dart';
import 'package:cineville/presentation/bloc/state/empty_state.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:dartz/dartz.dart';

class ActorsBloc extends Bloc<BlocEvent, BlocState> {
  final UseCase<Actor> getMovieActors;

  ActorsBloc(this.getMovieActors);

  @override
  BlocState get initialState => EmptyState();

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    yield LoadingState();
    Either<Failure, List<Actor>> useCaseResult;
    if (event is LoadMovieActorsEvent) {
      useCaseResult = await getMovieActors.execute(event.movieId);
    }
    yield useCaseResult.fold(
      (failure) => ErrorState(_mapFailureToMessage(failure)),
      (entities) => LoadedState<Actor>(entities),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return TranslatableStrings.SERVER_FAILURE_MESSAGE;
      case NetworkFailure:
        return TranslatableStrings.NETWORK_FAILURE_MESSAGE;
      case NoDataFailure:
        return TranslatableStrings.NO_ACTORS;
      default:
        return TranslatableStrings.UNEXPECTED_FAILURE_MESSAGE;
    }
  }
}
