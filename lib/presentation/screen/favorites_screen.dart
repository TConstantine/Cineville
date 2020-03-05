import 'package:cineville/di/injector.dart';
import 'package:cineville/presentation/bloc/favorite_list_bloc.dart';
import 'package:cineville/presentation/widget/drawer_view.dart';
import 'package:cineville/presentation/widget/favorite_movies_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${TranslatableStrings.FAVORITE} ${TranslatableStrings.MOVIES}'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: DrawerView(),
      body: BlocProvider(
        builder: (_) => injector<FavoriteListBloc>(),
        child: FavoriteMoviesView(),
      ),
    );
  }
}
