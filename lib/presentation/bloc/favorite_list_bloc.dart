import 'package:bloc/bloc.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/usecase/use_case_no_params.dart';
import 'package:cineville/presentation/bloc/bloc_event.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/event/load_favorite_movies_event.dart';
import 'package:cineville/presentation/bloc/state/empty_state.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:dartz/dartz.dart';

class FavoriteListBloc extends Bloc<BlocEvent, BlocState> {
  final UseCaseNoParams<List<Movie>> _getFavoriteMoviesUseCase;

  FavoriteListBloc(this._getFavoriteMoviesUseCase);

  @override
  BlocState get initialState => EmptyState();

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    yield LoadingState();
    if (event is LoadFavoriteMoviesEvent) {
      final Either<Failure, List<Movie>> useCaseResult = await _getFavoriteMoviesUseCase.execute();
      yield useCaseResult.fold(
        (failure) => ErrorState(TranslatableStrings.NO_FAVORITE_MOVIES),
        (favoriteMovies) => LoadedState(favoriteMovies),
      );
    }
  }
}
