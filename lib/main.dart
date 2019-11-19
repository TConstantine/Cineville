import 'package:cineville/application.dart';
import 'package:cineville/di/injector.dart';
import 'package:flutter/material.dart';

void main() async {
  await Injector().inject();
  runApp(CinevilleApplication());
}
