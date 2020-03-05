import 'package:cineville/di/injector.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/presentation/widget/movie_backdrop_view.dart';
import 'package:cineville/presentation/widget/movie_genres_view.dart';
import 'package:cineville/presentation/widget/movie_info_view.dart';
import 'package:cineville/presentation/widget/movie_poster_view.dart';
import 'package:cineville/presentation/widget/movie_title_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../builder/domain_entity_builder.dart';
import '../../builder/movie_domain_entity_builder.dart';
import '../../builder/test_widget_builder.dart';

void main() {
  DomainEntityBuilder movieDomainEntityBuilder;
  Movie testMovie;
  Injector dependencyInjector;
  Widget widget;

  setUp(() {
    movieDomainEntityBuilder = MovieDomainEntityBuilder();
    testMovie = movieDomainEntityBuilder.build();
    dependencyInjector = Injector();
    widget = MovieInfoView(
      movie: testMovie,
    );
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    injector.reset();
  });

  testWidgets('should display movie backdrop', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    expect(find.byType(MovieBackdropView), findsOneWidget);
  });

  testWidgets('should display movie poster', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    expect(find.byType(MoviePosterView), findsOneWidget);
  });

  testWidgets('should display movie title', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    expect(find.byType(MovieTitleView), findsOneWidget);
  });

  testWidgets('should display movie genres', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    expect(find.byType(MovieGenresView), findsOneWidget);
  });

  testWidgets('should display movie plot synopsis', (tester) async {
    await TestWidgetBuilder.runAsync(dependencyInjector, widget, tester);

    expect(find.text(testMovie.plotSynopsis), findsOneWidget);
  });
}
