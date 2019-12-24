import 'package:cineville/domain/entity/review.dart';
import 'package:cineville/presentation/widget/expandable_text_view.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';

class MovieReviewView extends StatelessWidget {
  final Review review;

  MovieReviewView({Key key, @required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Parent(
        style: ParentStyle()..padding(all: 12.0),
        child: Column(
          children: [
            ExpandableTextView(
              review.content,
              colorClickableText: Colors.pink,
              textStyle: TextStyle(fontSize: 16.0),
            ),
            _buildVerticalSpacing(),
            Txt(
              review.author,
              style: TxtStyle()
                ..alignment.centerRight()
                ..italic()
                ..opacity(0.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalSpacing() {
    return Parent(
      style: ParentStyle()..padding(vertical: 4.0),
    );
  }
}
