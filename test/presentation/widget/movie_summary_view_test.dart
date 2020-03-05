import 'package:cineville/di/injector.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/presentation/bloc/movies_bloc.dart';
import 'package:cineville/presentation/screen/movie_details_screen.dart';
import 'package:cineville/presentation/widget/movie_genre_view.dart';
import 'package:cineville/presentation/widget/movie_poster_view.dart';
import 'package:cineville/presentation/widget/movie_rating_view.dart';
import 'package:cineville/presentation/widget/movie_summary_view.dart';
import 'package:cineville/resources/widget_key.dart';
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
  Movie testMovie;
  MoviesBloc mockMoviesBloc;
  Injector dependencyInjector;
  Widget widget;

  setUp(() {
    movieDomainEntityBuilder = MovieDomainEntityBuilder();
    mockMoviesBloc = MockMoviesBloc();
    dependencyInjector = Injector().withMoviesBloc(mockMoviesBloc);
    testMovie = movieDomainEntityBuilder.build();
    widget = MaterialApp(
      home: MovieSummaryView(
        movie: testMovie,
      ),
    );
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    injector.reset();
  });

  testWidgets('should display movie poster', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    expect(find.byType(MoviePosterView), findsOneWidget);
  });

  testWidgets('should display movie rating', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    expect(find.byType(MovieRatingView), findsOneWidget);
  });

  testWidgets('should display movie title', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    expect(find.text('${testMovie.title} ${testMovie.releaseYear}'), findsOneWidget);
  });

  testWidgets('should display movie genres', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    expect(
      find.byType(MovieGenreView, skipOffstage: false),
      findsNWidgets(testMovie.genres.length),
    );
  });

  testWidgets('should display movie details when details button is clicked', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    await tester.tap(find.byKey(Key('${WidgetKey.DETAILS_BUTTON}_${testMovie.id}')));
    await tester.pump();
    await tester.pump();

    expect(find.byType(MovieDetailsScreen), findsOneWidget);
  });
}
