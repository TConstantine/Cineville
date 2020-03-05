import 'package:cineville/di/injector.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/presentation/bloc/movies_bloc.dart';
import 'package:cineville/presentation/screen/movie_details_screen.dart';
import 'package:cineville/presentation/widget/movie_actors_view.dart';
import 'package:cineville/presentation/widget/movie_details_navigation_bar_view.dart';
import 'package:cineville/presentation/widget/movie_info_view.dart';
import 'package:cineville/presentation/widget/movie_reviews_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../builder/domain_entity_builder.dart';
import '../../builder/movie_domain_entity_builder.dart';
import '../../builder/test_widget_builder.dart';

class MockMoviesBloc extends Mock implements MoviesBloc {}

void main() {
  DomainEntityBuilder movieDomainEntityBuilder;
  MoviesBloc mockMoviesBloc;
  Injector dependencyInjector;
  Widget widget;

  setUp(() {
    movieDomainEntityBuilder = MovieDomainEntityBuilder();
    mockMoviesBloc = MockMoviesBloc();
    dependencyInjector = Injector().withMoviesBloc(mockMoviesBloc);
    final Movie testMovie = movieDomainEntityBuilder.build();
    widget = MovieDetailsScreen(
      movie: testMovie,
    );
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    injector.reset();
  });

  testWidgets('should display movie details navigation bar', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    expect(find.byType(MovieDetailsNavigationBarView), findsOneWidget);
  });

  testWidgets('should display movie info by default', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    expect(find.byType(MovieInfoView), findsOneWidget);
  });

  testWidgets('should display movie actors when actors category is selected', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    await tester.tap(find.text(TranslatableStrings.CATEGORY_ACTORS));
    await tester.pump();

    expect(find.byType(MovieActorsView), findsOneWidget);
  });

  testWidgets('should display movie reviews when reviews category is selected', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    await tester.tap(find.text(TranslatableStrings.CATEGORY_REVIEWS));
    await tester.pump();

    expect(find.byType(MovieReviewsView), findsOneWidget);
  });
}
