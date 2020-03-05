import 'package:cineville/data/datasource/database_data_source.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/data_entity_type.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/domain/error/failure/network_failure.dart';
import 'package:cineville/domain/error/failure/no_data_failure.dart';
import 'package:cineville/domain/error/failure/server_failure.dart';
import 'package:cineville/data/mapper/video_domain_entity_mapper.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/domain/entity/video.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/video_repository.dart';
import 'package:dartz/dartz.dart';

class VideoDepository implements VideoRepository {
  final RemoteDataSource _remoteDataSource;
  final DatabaseDataSource _databaseDataSource;
  final Network _network;
  final VideoDomainEntityMapper _videoDomainEntityMapper;

  VideoDepository(
    this._remoteDataSource,
    this._databaseDataSource,
    this._network,
    this._videoDomainEntityMapper,
  );

  @override
  Future<Either<Failure, List<Video>>> getMovieVideos(int movieId) async {
    List<DataEntity> videoDataEntities = await _databaseDataSource.getMovieDataEntities(
      DataEntityType.VIDEO,
      movieId,
    );
    if (videoDataEntities.isEmpty) {
      if (!await _network.isConnected()) {
        return Left(NetworkFailure());
      }
      try {
        videoDataEntities = await _remoteDataSource.getMovieDataEntities(
          DataEntityType.VIDEO,
          movieId,
        );
      } on ServerException {
        return Left(ServerFailure());
      }
      if (videoDataEntities.isEmpty) {
        return Left(NoDataFailure());
      }
      _databaseDataSource.storeMovieDataEntities(DataEntityType.VIDEO, movieId, videoDataEntities);
    }
    return Right(_videoDomainEntityMapper.map(videoDataEntities));
  }
}
