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
            key: Key('drawerItem-movies'),
            icon: Icons.movie,
            onTap: () {
              return Navigator.pushReplacementNamed(context, Routes.MOVIES);
            },
            text: TranslatableStrings.MOVIES,
          ),
          _buildDisabledDrawerItem(
            icon: Icons.live_tv,
            text: TranslatableStrings.TV_SHOWS,
          ),
          Divider(),
          _buildDrawerItem(
            key: Key('drawerItem-favorite'),
            icon: Icons.favorite,
            onTap: () {
              return Navigator.pushReplacementNamed(context, Routes.FAVORITES);
            },
            text: TranslatableStrings.FAVORITE,
          ),
          _buildDisabledDrawerItemWithImage(
            image: Image.asset(AssetPath.WATCHED_CATEGORY),
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

  Widget _buildDrawerItem({Key key, IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      key: key,
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

  Widget _buildDisabledDrawerItem({IconData icon, String text}) {
    return ListTile(
      title: Row(
        children: [
          Icon(
            icon,
            color: Colors.black.withOpacity(0.5),
          ),
          Parent(
            style: ParentStyle()
              ..opacity(0.5)
              ..padding(left: 8.0),
            child: Text(text),
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledDrawerItemWithImage({Image image, String text}) {
    return ListTile(
      title: Row(
        children: [
          Parent(
            style: ParentStyle()
              ..height(24.0)
              ..opacity(0.5)
              ..width(24.0),
            child: image,
          ),
          Parent(
            style: ParentStyle()
              ..opacity(0.5)
              ..padding(left: 8.0),
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
