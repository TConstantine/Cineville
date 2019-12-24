import 'package:cineville/domain/entity/video.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/video_repository.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:dartz/dartz.dart';

class GetMovieVideos implements UseCase<Video> {
  final VideoRepository repository;

  GetMovieVideos(this.repository);

  @override
  Future<Either<Failure, List<Video>>> execute(int movieId) {
    return repository.getMovieVideos(movieId);
  }
}
