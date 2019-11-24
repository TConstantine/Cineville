import 'package:cineville/di/injector.dart';
import 'package:cineville/presentation/bloc/movies_bloc.dart';
import 'package:cineville/presentation/widget/drawer_view.dart';
import 'package:cineville/presentation/widget/movies_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:cineville/resources/untranslatable_stings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TranslatableStrings.APP_NAME),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: DrawerView(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocProvider(
              builder: (_) =>
                  injector(UntranslatableStrings.MOVIES_BLOC_WITH_GET_POPULAR_MOVIES_USE_CASE_KEY)
                      as MoviesBloc,
              child: MoviesView(
                title: TranslatableStrings.MOST_POPULAR_MOVIES_CATEGORY,
              ),
            ),
            BlocProvider(
              builder: (_) =>
                  injector(UntranslatableStrings.MOVIES_BLOC_WITH_GET_UPCOMING_MOVIES_USE_CASE_KEY)
                      as MoviesBloc,
              child: MoviesView(
                title: TranslatableStrings.UPCOMING_MOVIES_CATEGORY,
              ),
            ),
            BlocProvider<MoviesBloc>(
              builder: (_) =>
                  injector(UntranslatableStrings.MOVIES_BLOC_WITH_GET_TOP_RATED_MOVIES_USE_CASE_KEY)
                      as MoviesBloc,
              child: MoviesView(
                title: TranslatableStrings.TOP_RATED_MOVIES_CATEGORY,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
