import 'package:bloc/bloc.dart';
import 'package:cineville/domain/error/failure/network_failure.dart';
import 'package:cineville/domain/error/failure/no_data_failure.dart';
import 'package:cineville/domain/error/failure/server_failure.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:cineville/presentation/bloc/bloc_event.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/event/load_popular_movies_event.dart';
import 'package:cineville/presentation/bloc/event/load_similar_movies_event.dart';
import 'package:cineville/presentation/bloc/event/load_top_rated_movies_event.dart';
import 'package:cineville/presentation/bloc/event/load_upcoming_movies_event.dart';
import 'package:cineville/presentation/bloc/state/empty_state.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:dartz/dartz.dart';

class MoviesBloc extends Bloc<BlocEvent, BlocState> {
  final UseCaseWithParams<List<Movie>, int> getPopularMovies;
  final UseCaseWithParams<List<Movie>, int> getUpcomingMovies;
  final UseCaseWithParams<List<Movie>, int> getTopRatedMovies;
  final UseCaseWithParams<List<Movie>, int> getSimilarMovies;

  MoviesBloc(
    this.getPopularMovies,
    this.getUpcomingMovies,
    this.getTopRatedMovies,
    this.getSimilarMovies,
  );

  @override
  BlocState get initialState => EmptyState();

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    yield LoadingState();
    Either<Failure, List<Movie>> useCaseResult;
    if (event is LoadPopularMoviesEvent) {
      useCaseResult = await getPopularMovies.execute(event.page);
    } else if (event is LoadUpcomingMoviesEvent) {
      useCaseResult = await getUpcomingMovies.execute(event.page);
    } else if (event is LoadTopRatedMoviesEvent) {
      useCaseResult = await getTopRatedMovies.execute(event.page);
    } else if (event is LoadSimilarMoviesEvent) {
      useCaseResult = await getSimilarMovies.execute(event.movieId);
    }
    yield useCaseResult.fold(
      (failure) => ErrorState(_mapFailureToMessage(failure)),
      (entities) => LoadedState<List<Movie>>(entities),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return TranslatableStrings.SERVER_FAILURE_MESSAGE;
      case NetworkFailure:
        return TranslatableStrings.NETWORK_FAILURE_MESSAGE;
      case NoDataFailure:
        return TranslatableStrings.NO_DATA_FAILURE_MESSAGE;
      default:
        return TranslatableStrings.UNEXPECTED_FAILURE_MESSAGE;
    }
  }
}
