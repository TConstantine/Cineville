import 'package:popular_movies/data/model/genre_model.dart';

class GenreModelBuilder {
  int _id = 1;
  String _name = 'Genre name';

  GenreModelBuilder withId(int id) {
    _id = id;
    return this;
  }

  GenreModelBuilder withName(String name) {
    _name = name;
    return this;
  }

  GenreModel build() {
    return GenreModel(
      id: _id,
      name: _name,
    );
  }

  Map<String, dynamic> buildJson() {
    return {
      'id': _id,
      'name': _name,
    };
  }
}
