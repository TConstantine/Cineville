import 'package:cineville/domain/entity/review.dart';

class TestReviewBuilder {
  final String _author = 'Author';
  final String _content = 'Content';

  Review build() {
    return Review(author: _author, content: _content);
  }

  List<Review> buildMultiple() {
    return [build(), build(), build()];
  }
}
