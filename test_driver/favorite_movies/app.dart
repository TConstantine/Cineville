import 'package:cineville/application.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/entity/movie_data_entity.dart';
import 'package:cineville/di/injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

void main() async {
  enableFlutterDriverExtension();
  final RemoteDataSource mockRemoteDataSource = MockRemoteDataSource();
  when(mockRemoteDataSource.getMovies(any, any)).thenAnswer((_) async => _getPopularMovies());
  when(mockRemoteDataSource.getMovieGenres()).thenAnswer((_) async => []);
  await Injector().withRemoteDataSource(mockRemoteDataSource).inject();
  runApp(CinevilleApplication());
}

List<MovieDataEntity> _getPopularMovies() {
  return [
    MovieDataEntity(
      id: 1,
      title: 'Title 1',
      plotSynopsis: 'Plot synopsis 1',
      genreIds: [],
      rating: 0.0,
      posterUrl: '',
      backdropUrl: '',
      releaseDate: '2000-01-01',
      languageCode: 'en',
      popularity: 0.0,
    ),
    MovieDataEntity(
      id: 2,
      title: 'Title 2',
      plotSynopsis: 'Plot synopsis 2',
      genreIds: [],
      rating: 0.0,
      posterUrl: '',
      backdropUrl: '',
      releaseDate: '2000-01-01',
      languageCode: 'en',
      popularity: 0.0,
    ),
    MovieDataEntity(
      id: 3,
      title: 'Title 3',
      plotSynopsis: 'Plot synopsis 3',
      genreIds: [],
      rating: 0.0,
      posterUrl: '',
      backdropUrl: '',
      releaseDate: '2000-01-01',
      languageCode: 'en',
      popularity: 0.0,
    ),
  ];
}
