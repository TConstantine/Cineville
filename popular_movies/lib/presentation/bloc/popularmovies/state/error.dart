import 'package:popular_movies/presentation/bloc/popularmovies/popular_movies_state.dart';

class Error extends PopularMoviesState {
  static const String SERVER_FAILURE_MESSAGE = 'Server is not responding';
  static const String NETWORK_FAILURE_MESSAGE = 'There is no internet connection';
  static const String CACHE_FAILURE_MESSAGE =
      'There was an unexpected error. Please try re-installing the app, we are very sorry for the inconvenience.';
  static const String UNEXPECTED_FAILURE_MESSAGE = 'Unexpected failure';

  final String message;

  Error(this.message);

  @override
  List<Object> get props => [message];
}
