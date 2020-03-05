import 'package:bloc/bloc.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:cineville/presentation/bloc/bloc_event.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/event/add_movie_to_favorite_list_event.dart';
import 'package:cineville/presentation/bloc/event/is_favorite_movie_event.dart';
import 'package:cineville/presentation/bloc/event/remove_movie_from_favorite_list_event.dart';
import 'package:cineville/presentation/bloc/state/added_state.dart';
import 'package:cineville/presentation/bloc/state/empty_state.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/removed_state.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:dartz/dartz.dart';

class FavoriteMovieBloc extends Bloc<BlocEvent, BlocState> {
  final UseCaseWithParams<bool, int> _isFavoriteMovieUseCase;
  final UseCaseWithParams<void, int> _addMovieToFavoriteListUseCase;
  final UseCaseWithParams<int, int> _removeMovieFromFavoriteListUseCase;

  FavoriteMovieBloc(
    this._isFavoriteMovieUseCase,
    this._addMovieToFavoriteListUseCase,
    this._removeMovieFromFavoriteListUseCase,
  );

  @override
  BlocState get initialState => EmptyState();

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is IsFavoriteMovieEvent) {
      final Either<Failure, bool> useCaseResult =
          await _isFavoriteMovieUseCase.execute(event.movieId);
      yield useCaseResult.fold(
        (failure) => ErrorState(TranslatableStrings.UNEXPECTED_FAILURE_MESSAGE),
        (isFavorite) => LoadedState(isFavorite),
      );
    } else if (event is AddMovieToFavoriteListEvent) {
      final Either<Failure, void> useCaseResult =
          await _addMovieToFavoriteListUseCase.execute(event.movieId);
      yield useCaseResult.fold(
        (failure) => ErrorState(TranslatableStrings.UNEXPECTED_FAILURE_MESSAGE),
        (success) => AddedState(TranslatableStrings.ADDED_TO_FAVORITES),
      );
    } else if (event is RemoveMovieFromFavoriteListEvent) {
      final Either<Failure, int> useCaseResult =
          await _removeMovieFromFavoriteListUseCase.execute(event.movieId);
      yield useCaseResult.fold(
        (failure) => ErrorState(TranslatableStrings.UNEXPECTED_FAILURE_MESSAGE),
        (success) => RemovedState(TranslatableStrings.REMOVED_FROM_FAVORITES),
      );
    }
  }
}
