import 'package:cineville/di/injector.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/presentation/bloc/bloc_state.dart';
import 'package:cineville/presentation/bloc/favorite_list_bloc.dart';
import 'package:cineville/presentation/bloc/movies_bloc.dart';
import 'package:cineville/presentation/bloc/state/empty_state.dart';
import 'package:cineville/presentation/bloc/state/error_state.dart';
import 'package:cineville/presentation/bloc/state/loaded_state.dart';
import 'package:cineville/presentation/bloc/state/loading_state.dart';
import 'package:cineville/presentation/screen/favorites_screen.dart';
import 'package:cineville/presentation/widget/movie_summary_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../builder/domain_entity_builder.dart';
import '../../builder/movie_domain_entity_builder.dart';
import '../../builder/test_widget_builder.dart';

class MockMoviesBloc extends Mock implements MoviesBloc {}

class MockFavoriteListBloc extends Mock implements FavoriteListBloc {}

void main() {
  DomainEntityBuilder movieDomainEntityBuilder;
  List<Movie> testFavoriteMovies;
  MoviesBloc mockMoviesBloc;
  FavoriteListBloc mockFavoriteListBloc;
  Injector dependencyInjector;
  Widget widget;

  setUp(() {
    movieDomainEntityBuilder = MovieDomainEntityBuilder();
    testFavoriteMovies = movieDomainEntityBuilder.buildList();
    mockMoviesBloc = MockMoviesBloc();
    mockFavoriteListBloc = MockFavoriteListBloc();
    dependencyInjector =
        Injector().withMoviesBloc(mockMoviesBloc).withFavoriteListBloc(mockFavoriteListBloc);
    widget = FavoritesScreen();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    injector.reset();
  });

  testWidgets('should display a message when there are no favorite movies', (tester) async {
    final List<BlocState> testStates = [
      EmptyState(),
      LoadingState(),
      ErrorState(TranslatableStrings.NO_FAVORITE_MOVIES),
    ];
    when(mockFavoriteListBloc.state).thenAnswer((_) => Stream.fromIterable(testStates));
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester, pumpAndSettle: true);

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.text(TranslatableStrings.NO_FAVORITE_MOVIES), findsOneWidget);
  });

  testWidgets('should display favorite movies', (tester) async {
    final List<BlocState> testStates = [
      EmptyState(),
      LoadingState(),
      LoadedState<List<Movie>>(testFavoriteMovies),
    ];
    when(mockFavoriteListBloc.state).thenAnswer((_) => Stream.fromIterable(testStates));
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester, pumpAndSettle: true);

    expect(find.byType(MovieSummaryView), findsNWidgets(testFavoriteMovies.length));
  });
}
