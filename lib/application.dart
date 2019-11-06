import 'package:flutter/material.dart';
import 'package:popular_movies/presentation/screen/home_screen.dart';

class CinevilleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
