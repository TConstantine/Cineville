import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:popular_movies/data/error/failure/cache_failure.dart';
import 'package:popular_movies/data/error/failure/network_failure.dart';
import 'package:popular_movies/data/error/failure/server_failure.dart';
import 'package:popular_movies/domain/entity/movie.dart';
import 'package:popular_movies/domain/error/failure/failure.dart';
import 'package:popular_movies/domain/usecase/get_popular_movies.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/event/load_popular_movies.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/popular_movies_event.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/popular_movies_state.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/state/empty.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/state/error.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/state/loaded.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/state/loading.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies _getPopularMovies;

  PopularMoviesBloc(this._getPopularMovies);

  @override
  get initialState => Empty();

  @override
  Stream<PopularMoviesState> mapEventToState(PopularMoviesEvent event) async* {
    if (event is LoadPopularMovies) {
      yield Loading();
      final Either<Failure, List<Movie>> useCaseResult =
          await _getPopularMovies.execute(event.page);
      yield useCaseResult.fold(
        (failure) => Error(_mapFailureToMessage(failure)),
        (movies) => Loaded(movies),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return Error.SERVER_FAILURE_MESSAGE;
      case NetworkFailure:
        return Error.NETWORK_FAILURE_MESSAGE;
      case CacheFailure:
        return Error.CACHE_FAILURE_MESSAGE;
      default:
        return Error.UNEXPECTED_FAILURE_MESSAGE;
    }
  }
}
