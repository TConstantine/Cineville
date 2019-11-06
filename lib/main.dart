import 'package:cineville/application.dart';
import 'package:flutter/material.dart';
import 'package:popular_movies/di/injector.dart';

void main() async {
  await Injector().inject();
  runApp(CinevilleApplication());
}
