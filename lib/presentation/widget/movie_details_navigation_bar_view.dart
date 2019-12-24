import 'package:cineville/resources/translatable_strings.dart';
import 'package:flutter/material.dart';

class MovieDetailsNavigationBarView extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  MovieDetailsNavigationBarView({Key key, @required this.currentIndex, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          title: Text(TranslatableStrings.CATEGORY_INFO),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          title: Text(TranslatableStrings.CATEGORY_ACTORS),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rate_review),
          title: Text(TranslatableStrings.CATEGORY_REVIEWS),
        ),
      ],
      onTap: onTap,
    );
  }
}
