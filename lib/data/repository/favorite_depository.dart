import 'package:cineville/data/datasource/database_data_source.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/movie_data_entity.dart';
import 'package:cineville/domain/error/failure/no_data_failure.dart';
import 'package:cineville/data/mapper/movie_domain_entity_mapper.dart';
import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/favorite_repository.dart';
import 'package:cineville/resources/movie_category.dart';
import 'package:dartz/dartz.dart';

class FavoriteDepository implements FavoriteRepository {
  final DatabaseDataSource _databaseDataSource;
  final MovieDomainEntityMapper _movieDomainEntitymapper;

  FavoriteDepository(this._databaseDataSource, this._movieDomainEntitymapper);

  @override
  Future<Either<Failure, List<Movie>>> getMovies() async {
    final List<DataEntity> movieDataEntities =
        await _databaseDataSource.getMovies(MovieCategory.FAVORITE);
    if (movieDataEntities.isNotEmpty) {
      List<int> genreIds = [];
      List<MovieDataEntity>.from(movieDataEntities).forEach((movieDataEntity) {
        genreIds.addAll(movieDataEntity.genreIds);
      });
      genreIds = genreIds.toSet().toList();
      final List<DataEntity> genreDataEntities = await _databaseDataSource.getMovieGenres(genreIds);
      return Right(_movieDomainEntitymapper.map(movieDataEntities, genreDataEntities));
    }
    return Left(NoDataFailure());
  }

  @override
  Future<Either<Failure, bool>> isMovieMarkedAsFavorite(int movieId) async {
    return Right(await _databaseDataSource.isMovieMarkedAsFavorite(movieId));
  }

  @override
  Future<Either<Failure, void>> markMovieAsFavorite(int movieId) async {
    return Right(await _databaseDataSource.markMovieAsFavorite(movieId));
  }

  @override
  Future<Either<Failure, int>> removeMovieFromFavorites(int movieId) async {
    return Right(await _databaseDataSource.removeMovieFromFavorites(movieId));
  }
}
