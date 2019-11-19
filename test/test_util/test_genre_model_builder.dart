import 'package:cineville/data/model/genre_model.dart';

class TestGenreModelBuilder {
  int _id = 1;
  String _name = 'Genre name';

  TestGenreModelBuilder withId(int id) {
    _id = id;
    return this;
  }

  TestGenreModelBuilder withName(String name) {
    _name = name;
    return this;
  }

  GenreModel build() {
    return GenreModel(
      id: _id,
      name: _name,
    );
  }

  List<GenreModel> buildMultiple() {
    return [build(), build(), build()];
  }

  Map<String, dynamic> buildJson() {
    return {
      'id': _id,
      'name': _name,
    };
  }

  List<Map<String, dynamic>> buildJsonMultiple() {
    return [buildJson(), buildJson(), buildJson()];
  }
}
