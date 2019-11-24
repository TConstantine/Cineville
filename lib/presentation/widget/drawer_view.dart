import 'package:cineville/presentation/widget/attributions_view.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:cineville/resources/untranslatable_stings.dart';
import 'package:flutter/material.dart';

class DrawerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            key: Key(UntranslatableStrings.ATTRIBUTIONS_OPTION_KEY),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AttributionsView();
                },
              );
            },
            title: Text(TranslatableStrings.ATTRIBUTIONS),
          ),
        ],
      ),
    );
  }
}
