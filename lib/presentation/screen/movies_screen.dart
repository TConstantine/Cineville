import 'package:cineville/di/injector.dart';
import 'package:cineville/presentation/bloc/bloc_event.dart';
import 'package:cineville/presentation/bloc/event/load_popular_movies_event.dart';
import 'package:cineville/presentation/bloc/event/load_top_rated_movies_event.dart';
import 'package:cineville/presentation/bloc/event/load_upcoming_movies_event.dart';
import 'package:cineville/presentation/bloc/movies_bloc.dart';
import 'package:cineville/presentation/widget/categories_navigation_bar_view.dart';
import 'package:cineville/presentation/widget/drawer_view.dart';
import 'package:cineville/presentation/widget/movies_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  int currentIndex;
  BlocEvent currentEvent;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    currentEvent = LoadPopularMoviesEvent(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${TranslatableStrings.APP_NAME} - ${TranslatableStrings.MOVIES}'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: CategoriesNavigationBarView(
        currentIndex: currentIndex,
        onTap: _handleTap,
      ),
      drawer: DrawerView(),
      body: Parent(
        style: ParentStyle()..padding(top: 16.0),
        child: BlocProvider(
          builder: (_) => injector<MoviesBloc>(),
          child: MoviesView(
            event: currentEvent,
          ),
        ),
      ),
    );
  }

  void _handleTap(int index) {
    if (index != currentIndex) {
      currentIndex = index;
      switch (index) {
        case 0:
          currentEvent = LoadPopularMoviesEvent(1);
          break;
        case 1:
          currentEvent = LoadUpcomingMoviesEvent(1);
          break;
        case 2:
          currentEvent = LoadTopRatedMoviesEvent(1);
          break;
      }
      setState(() {});
    }
  }
}
