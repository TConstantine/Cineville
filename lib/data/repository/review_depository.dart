import 'package:cineville/data/datasource/local_data_source.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/data/error/failure/network_failure.dart';
import 'package:cineville/data/error/failure/server_failure.dart';
import 'package:cineville/data/mapper/review_mapper.dart';
import 'package:cineville/data/model/review_model.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/domain/entity/review.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/review_repository.dart';
import 'package:dartz/dartz.dart';

class ReviewDepository implements ReviewRepository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final Network _network;
  final ReviewMapper _reviewMapper;

  ReviewDepository(
    this._remoteDataSource,
    this._localDataSource,
    this._network,
    this._reviewMapper,
  );

  @override
  Future<Either<Failure, List<Review>>> getMovieReviews(int movieId) async {
    List<ReviewModel> reviewModels;
    reviewModels = await _localDataSource.getMovieReviews(movieId);
    if (reviewModels.isEmpty) {
      if (await _network.isConnected()) {
        try {
          reviewModels = await _remoteDataSource.getMovieReviews(movieId);
        } on ServerException {
          return Left(ServerFailure());
        }
        if (reviewModels.isNotEmpty) {
          _localDataSource.storeMovieReviews(movieId, reviewModels);
        }
      } else {
        return Left(NetworkFailure());
      }
    }
    return Right(_reviewMapper.map(reviewModels));
  }
}
