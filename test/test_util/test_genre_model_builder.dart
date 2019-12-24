import 'package:cineville/data/model/genre_model.dart';

class TestGenreModelBuilder {
  int genreId = 1;
  String genreName = 'Genre name';
  List<int> _ids = [];
  List<String> _genreNames = [];

  TestGenreModelBuilder withId(int id) {
    genreId = id;
    return this;
  }

  TestGenreModelBuilder withIds(List<int> ids) {
    _ids = ids;
    return this;
  }

  TestGenreModelBuilder withName(String name) {
    genreName = name;
    return this;
  }

  TestGenreModelBuilder withNames(List<String> names) {
    _genreNames = names;
    return this;
  }

  GenreModel build() {
    return GenreModel(
      id: genreId,
      name: genreName,
    );
  }

  List<GenreModel> buildMultiple() {
    return List.generate(3, (index) {
      if (_ids.isNotEmpty) {
        genreId = _ids[index];
      }
      if (_genreNames.isNotEmpty) {
        genreName = _genreNames[index];
      }
      return build();
    });
  }

  Map<String, dynamic> buildJson() {
    return {
      'id': genreId,
      'name': genreName,
    };
  }

  List<Map<String, dynamic>> buildMultipleJson() {
    return [buildJson(), buildJson(), buildJson()];
  }
}
