import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/mapper/movie_domain_entity_mapper.dart';
import 'package:cineville/domain/entity/movie.dart';

import 'data_entity_builder.dart';
import 'domain_entity_builder.dart';
import 'genre_data_entity_builder.dart';
import 'movie_data_entity_builder.dart';

class MovieDomainEntityBuilder extends DomainEntityBuilder {
  @override
  List<Movie> buildList() {
    final DataEntityBuilder movieDataEntityBuilder = MovieDataEntityBuilder();
    final List<DataEntity> movieDataEntities = movieDataEntityBuilder.buildList();
    final DataEntityBuilder genreDataEntityBuilder = GenreDataEntityBuilder();
    final List<DataEntity> genreDataEntities = genreDataEntityBuilder.buildList();
    final MovieDomainEntityMapper movieMapper = MovieDomainEntityMapper();
    return movieMapper.map(movieDataEntities, genreDataEntities);
  }
}
