import 'package:cineville/domain/entity/video.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/video_repository.dart';
import 'package:cineville/domain/usecase/get_movie_videos_use_case.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../builder/domain_entity_builder.dart';
import '../../builder/video_domain_entity_builder.dart';

class MockVideoRepository extends Mock implements VideoRepository {}

void main() {
  DomainEntityBuilder videoDomainEntityBuilder;
  VideoRepository mockVideoRepository;
  UseCaseWithParams<List<Video>, int> useCaseWithParams;

  setUp(() {
    videoDomainEntityBuilder = VideoDomainEntityBuilder();
    mockVideoRepository = MockVideoRepository();
    useCaseWithParams = GetMovieVideosUseCase(mockVideoRepository);
  });

  test('should retrieve movie videos for a specific movie from the video repository', () async {
    final int movieId = 1;
    final List<Video> videoDomainEntities = videoDomainEntityBuilder.buildList();
    when(mockVideoRepository.getMovieVideos(any)).thenAnswer((_) async => Right(videoDomainEntities));

    final Either<Failure, List<Video>> result = await useCaseWithParams.execute(movieId);

    verify(mockVideoRepository.getMovieVideos(movieId));
    expect(result, Right(videoDomainEntities));
  });
}
