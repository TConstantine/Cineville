import 'package:cineville/application.dart';
import 'package:cineville/di/injector.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injector().inject();
  runApp(CinevilleApplication());
}
