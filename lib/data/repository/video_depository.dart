import 'package:cineville/data/datasource/local_data_source.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/data/error/failure/network_failure.dart';
import 'package:cineville/data/error/failure/no_data_failure.dart';
import 'package:cineville/data/error/failure/server_failure.dart';
import 'package:cineville/data/mapper/video_mapper.dart';
import 'package:cineville/data/model/video_model.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/domain/entity/video.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/video_repository.dart';
import 'package:dartz/dartz.dart';

class VideoDepository implements VideoRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final Network network;
  final VideoMapper mapper;

  VideoDepository(this.remoteDataSource, this.localDataSource, this.network, this.mapper);

  @override
  Future<Either<Failure, List<Video>>> getMovieVideos(int movieId) async {
    List<VideoModel> videoModels = await localDataSource.getMovieVideos(movieId);
    if (videoModels.isEmpty) {
      if (!await network.isConnected()) {
        return Left(NetworkFailure());
      }
      try {
        videoModels = await remoteDataSource.getMovieVideos(movieId);
      } on ServerException {
        return Left(ServerFailure());
      }
      if (videoModels.isEmpty) {
        return Left(NoDataFailure());
      }
      localDataSource.storeMovieVideos(movieId, videoModels);
    }
    return Right(mapper.map(videoModels));
  }
}
