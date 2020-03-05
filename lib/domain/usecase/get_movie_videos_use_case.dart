import 'package:cineville/domain/entity/video.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/video_repository.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:dartz/dartz.dart';

class GetMovieVideosUseCase implements UseCaseWithParams<List<Video>, int> {
  final VideoRepository _videoRepository;

  GetMovieVideosUseCase(this._videoRepository);

  @override
  Future<Either<Failure, List<Video>>> execute(int movieId) {
    return _videoRepository.getMovieVideos(movieId);
  }
}
