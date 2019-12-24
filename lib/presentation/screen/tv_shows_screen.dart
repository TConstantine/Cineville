import 'package:cineville/presentation/widget/drawer_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:flutter/material.dart';

class TvShowsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('${TranslatableStrings.APP_NAME} - ${TranslatableStrings.TV_SHOWS}'),
      ),
      drawer: DrawerView(),
      body: Center(
        child: Text('Under Construction...'),
      ),
    );
  }
}
