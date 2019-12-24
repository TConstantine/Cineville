import 'package:cineville/domain/entity/video.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/video_repository.dart';
import 'package:cineville/domain/usecase/get_movie_videos.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/test_video_builder.dart';

class MockRepository extends Mock implements VideoRepository {}

void main() {
  VideoRepository mockRepository;
  UseCase<Video> useCase;

  setUp(() {
    mockRepository = MockRepository();
    useCase = GetMovieVideos(mockRepository);
  });

  final List<Video> testVideos = TestVideoBuilder().buildMultiple();
  final int testMovieId = 100;

  test('should retrieve movie videos for a specific movie from the video repository', () async {
    when(mockRepository.getMovieVideos(any)).thenAnswer((_) async => Right(testVideos));

    final Either<Failure, List<Video>> result = await useCase.execute(testMovieId);

    expect(result, Right(testVideos));
    verify(mockRepository.getMovieVideos(testMovieId));
    verifyNoMoreInteractions(mockRepository);
  });
}
