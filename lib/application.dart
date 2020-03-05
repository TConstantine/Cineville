import 'package:cineville/presentation/screen/favorites_screen.dart';
import 'package:cineville/presentation/screen/movies_screen.dart';
import 'package:cineville/resources/routes.dart';
import 'package:flutter/material.dart';

class CinevilleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.MOVIES,
      routes: {
        Routes.FAVORITES: (_) => FavoritesScreen(),
        Routes.MOVIES: (_) => MoviesScreen(),
      },
      theme: ThemeData(
        accentColor: Colors.orange.shade300,
        backgroundColor: Colors.grey.shade200,
        primaryColor: Colors.grey.shade900,
      ),
    );
  }
}
