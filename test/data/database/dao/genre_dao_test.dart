import 'package:cineville/data/database/dao/genre_dao.dart';
import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/genre_data_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor_ffi/moor_ffi.dart';

import '../../../builder/data_entity_builder.dart';
import '../../../builder/genre_data_entity_builder.dart';
import '../../../builder/genre_id_builder.dart';

void main() {
  DataEntityBuilder genreDataEntityBuilder;
  Database database;
  GenreDao genreDao;

  setUp(() {
    genreDataEntityBuilder = GenreDataEntityBuilder();
    database = Database(VmDatabase.memory());
    genreDao = GenreDao(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('should not return any genres when cache is empty', () async {
    final List<int> genreIds = GenreIdBuilder.buildList();

    final List<DataEntity> genreDataEntities = await genreDao.getMovieGenres(genreIds);

    expect(genreDataEntities.isEmpty, true);
  });

  test('should return genres when cache is not empty', () async {
    final List<int> genreIds = GenreIdBuilder.buildList();
    final List<GenreDataEntity> genreDataEntityList =
        List<GenreDataEntity>.from(genreDataEntityBuilder.buildList());
    await genreDao.storeMovieGenres(genreDataEntityList);

    final List<GenreDataEntity> genreDataEntities = await genreDao.getMovieGenres(genreIds);

    expect(genreDataEntities.length, genreDataEntityList.length);
    expect(genreDataEntities.first.id, genreDataEntityList.first.id);
    expect(genreDataEntities[1].id, genreDataEntityList[1].id);
    expect(genreDataEntities[2].id, genreDataEntityList[2].id);
    expect(genreDataEntities[3].id, genreDataEntityList[3].id);
    expect(genreDataEntities.last.id, genreDataEntityList.last.id);
  });

  test('should return genres ordered by name', () async {
    final List<int> genreIds = GenreIdBuilder.buildList();
    final List<DataEntity> genreDataEntityList = genreDataEntityBuilder.buildList();
    await genreDao.storeMovieGenres(genreDataEntityList);

    final List<GenreDataEntity> genreDataEntities = await genreDao.getMovieGenres(genreIds);

    expect(genreDataEntities.length, genreDataEntityList.length);
    expect(genreDataEntities.first.name, 'Action');
    expect(genreDataEntities[1].name, 'Adventure');
    expect(genreDataEntities[2].name, 'Comedy');
    expect(genreDataEntities[3].name, 'Crime');
    expect(genreDataEntities.last.name, 'Drama');
  });

  test('should store genres', () async {
    final List<int> genreIds = GenreIdBuilder.buildList();
    final List<DataEntity> genreDataEntityList = genreDataEntityBuilder.buildList();

    await genreDao.storeMovieGenres(genreDataEntityList);

    final List<DataEntity> genreDataEntities = await genreDao.getMovieGenres(genreIds);
    expect(genreDataEntities.length, genreDataEntityList.length);
  });

  test('should not create duplicate genre entries', () async {
    final List<int> genreIds = GenreIdBuilder.buildList();
    final DataEntity genreDataEntity = genreDataEntityBuilder.build();
    final List<DataEntity> genreDataEntityList = [
      genreDataEntity,
      genreDataEntity,
      genreDataEntity
    ];

    await genreDao.storeMovieGenres(genreDataEntityList);

    final List<DataEntity> genreDataEntities = await genreDao.getMovieGenres(genreIds);
    expect(genreDataEntities.length, 1);
  });
}
