import 'package:cineville/domain/entity/video.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:dartz/dartz.dart';

abstract class VideoRepository {
  Future<Either<Failure, List<Video>>> getMovieVideos(int movieId);
}
