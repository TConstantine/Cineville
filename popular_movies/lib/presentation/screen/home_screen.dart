import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popular_movies/di/injector.dart';
import 'package:popular_movies/presentation/bloc/popularmovies/popular_movies_bloc.dart';
import 'package:popular_movies/presentation/widget/popular_movies.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cineville'),
      ),
      body: BlocProvider(
        builder: (_) => injector<PopularMoviesBloc>(),
        child: PopularMovies(),
      ),
    );
  }
}
