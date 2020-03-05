import 'package:bloc/bloc.dart';
import 'package:cineville/domain/error/failure/network_failure.dart';
import 'package:cineville/domain/error/failure/no_data_failure.dart';
import 'package:cineville/domain/error/failure/server_failure.dart';
import 'package:cineville/domain/entity/review.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:cineville/presentation/bloc/bloc_event.dart';
import 'package:cineville/presentation/bloc/event/load_movie_reviews_event.dart';
import 'package:cineville/presentation/bloc/state/empty_state.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:dartz/dartz.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';

class ReviewsBloc extends Bloc<BlocEvent, BlocState> {
  final UseCaseWithParams<List<Review>, int> getMovieReviews;

  ReviewsBloc(this.getMovieReviews);

  @override
  BlocState get initialState => EmptyState();

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    yield LoadingState();
    Either<Failure, List<Review>> useCaseResult;
    if (event is LoadMovieReviewsEvent) {
      useCaseResult = await getMovieReviews.execute(event.movieId);
    }
    yield useCaseResult.fold(
      (failure) => ErrorState(_mapFailureToMessage(failure)),
      (entities) => LoadedState<List<Review>>(entities),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return TranslatableStrings.SERVER_FAILURE_MESSAGE;
      case NetworkFailure:
        return TranslatableStrings.NETWORK_FAILURE_MESSAGE;
      case NoDataFailure:
        return TranslatableStrings.NO_REVIEWS;
      default:
        return TranslatableStrings.UNEXPECTED_FAILURE_MESSAGE;
    }
  }
}
