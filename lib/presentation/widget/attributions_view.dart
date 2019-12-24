import 'package:cineville/resources/asset_path.dart';
import 'package:cineville/resources/translatable_strings.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AttributionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        FlatButton(
          textColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(TranslatableStrings.CLOSE),
        ),
      ],
      backgroundColor: Theme.of(context).backgroundColor,
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Parent(
              style: ParentStyle()..padding(bottom: 16.0),
              child: Image.asset(AssetPath.TMDB_LOGO),
            ),
            Parent(
              style: ParentStyle()..padding(horizontal: 16.0),
              child: Txt(
                TranslatableStrings.TMDB_ATTRIBUTION_MESSAGE,
                style: TxtStyle()..textColor(Colors.grey.shade700),
              ),
            ),
          ],
        ),
      ),
      title: Txt(
        TranslatableStrings.ATTRIBUTIONS,
        style: TxtStyle()
          ..bold()
          ..fontSize(25.0),
      ),
    );
  }
}
