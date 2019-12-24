import 'package:cineville/presentation/widget/attributions_view.dart';
import 'package:cineville/resources/asset_path.dart';
import 'package:cineville/resources/routes.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';

class DrawerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context),
          _buildDrawerItem(
            icon: Icons.movie,
            onTap: () {
              return Navigator.pushReplacementNamed(context, Routes.MOVIES);
            },
            text: TranslatableStrings.MOVIES,
          ),
          _buildDrawerItem(
            icon: Icons.live_tv,
            onTap: () {
              return Navigator.pushReplacementNamed(context, Routes.TV_SHOWS);
            },
            text: TranslatableStrings.TV_SHOWS,
          ),
          Divider(),
          _buildDrawerItem(
            icon: Icons.favorite,
            onTap: () {},
            text: TranslatableStrings.FAVORITE,
          ),
          _buildDrawerItemWithImage(
            image: Image.asset(AssetPath.WATCHED_CATEGORY),
            onTap: () {},
            text: TranslatableStrings.WATCHED,
          ),
          Divider(),
          _buildDrawerItemWithoutIcon(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AttributionsView();
                },
              );
            },
            text: TranslatableStrings.ATTRIBUTIONS,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      child: Icon(
        Icons.account_circle,
        color: Colors.white,
        size: 96.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildDrawerItem({IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      onTap: onTap,
      title: Row(
        children: [
          Icon(icon),
          Parent(
            style: ParentStyle()..padding(left: 8.0),
            child: Text(text),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItemWithImage({Image image, String text, GestureTapCallback onTap}) {
    return ListTile(
      onTap: onTap,
      title: Row(
        children: [
          Parent(
            style: ParentStyle()
              ..height(24.0)
              ..width(24.0),
            child: image,
          ),
          Parent(
            style: ParentStyle()..padding(left: 8.0),
            child: Text(text),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItemWithoutIcon({String text, GestureTapCallback onTap}) {
    return ListTile(
      onTap: onTap,
      title: Text(text),
    );
  }
}
