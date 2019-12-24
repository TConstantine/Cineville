import 'package:cineville/data/model/review_model.dart';

class TestReviewModelBuilder {
  String author = 'Author';
  String content = 'Content';
  List<String> _authors = [];

  TestReviewModelBuilder withAuthors(List<String> authors) {
    _authors = authors;
    return this;
  }

  ReviewModel build() {
    return ReviewModel(author: author, content: content);
  }

  List<ReviewModel> buildMultiple() {
    return List.generate(3, (index) {
      if (_authors.isNotEmpty) {
        author = _authors[index];
      }
      return build();
    });
  }

  Map<String, dynamic> buildJson() {
    return {'author': author, 'content': content};
  }

  List<Map<String, dynamic>> buildMultipleJson() {
    return List.generate(3, (_) => buildJson());
  }
}
