import 'package:cineville/data/datasource/database_data_source.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/data_entity_type.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/domain/error/failure/network_failure.dart';
import 'package:cineville/domain/error/failure/no_data_failure.dart';
import 'package:cineville/domain/error/failure/server_failure.dart';
import 'package:cineville/data/mapper/review_domain_entity_mapper.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/domain/entity/review.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/review_repository.dart';
import 'package:dartz/dartz.dart';

class ReviewDepository implements ReviewRepository {
  final RemoteDataSource _remoteDataSource;
  final DatabaseDataSource _databaseDataSource;
  final Network _network;
  final ReviewDomainEntityMapper _reviewDomainEntityMapper;

  ReviewDepository(
    this._remoteDataSource,
    this._databaseDataSource,
    this._network,
    this._reviewDomainEntityMapper,
  );

  @override
  Future<Either<Failure, List<Review>>> getMovieReviews(int movieId) async {
    List<DataEntity> reviewDataEntities = await _databaseDataSource.getMovieDataEntities(
      DataEntityType.REVIEW,
      movieId,
    );
    if (reviewDataEntities.isEmpty) {
      if (await _network.isConnected()) {
        try {
          reviewDataEntities = await _remoteDataSource.getMovieDataEntities(
            DataEntityType.REVIEW,
            movieId,
          );
        } on ServerException {
          return Left(ServerFailure());
        }
        if (reviewDataEntities.isEmpty) {
          return Left(NoDataFailure());
        }
        _databaseDataSource.storeMovieDataEntities(
          DataEntityType.REVIEW,
          movieId,
          reviewDataEntities,
        );
      } else {
        return Left(NetworkFailure());
      }
    }
    return Right(_reviewDomainEntityMapper.map(reviewDataEntities));
  }
}
