import 'package:cineville/resources/translatable_strings.dart';
import 'package:cineville/resources/untranslatable_stings.dart';
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
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
              ),
              child: Image.asset(UntranslatableStrings.TMDB_LOGO_PATH),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: Text(
                TranslatableStrings.TMDB_ATTRIBUTION_MESSAGE,
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
      title: Text(
        TranslatableStrings.ATTRIBUTIONS,
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
