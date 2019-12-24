import 'package:cineville/resources/asset_path.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';

class CategoriesNavigationBarView extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CategoriesNavigationBarView({Key key, @required this.currentIndex, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ParentStyle upcomingCategoryStyle = ParentStyle()
      ..height(24.0)
      ..width(24.0)
      ..opacity(0.5);
    if (currentIndex == 1) {
      upcomingCategoryStyle..opacity(1.0);
    }
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          title: Text(TranslatableStrings.CATEGORY_POPULAR),
        ),
        BottomNavigationBarItem(
          icon: Parent(
            style: upcomingCategoryStyle,
            child: Image.asset(AssetPath.UPCOMING_CATEGORY),
          ),
          title: Text(TranslatableStrings.CATEGORY_UPCOMING),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          title: Text(TranslatableStrings.CATEGORY_TOP_RATED),
        ),
      ],
      onTap: onTap,
    );
  }
}
