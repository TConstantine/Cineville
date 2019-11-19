import 'package:cineville/presentation/screen/home_screen.dart';
import 'package:flutter/material.dart';

class CinevilleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
