import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/actor_repository.dart';
import 'package:cineville/domain/usecase/use_case_with_params.dart';
import 'package:dartz/dartz.dart';

class GetMovieActorsUseCase implements UseCaseWithParams<List<Actor>, int> {
  final ActorRepository _actorRepository;

  GetMovieActorsUseCase(this._actorRepository);

  @override
  Future<Either<Failure, List<Actor>>> execute(int movieId) {
    return _actorRepository.getMovieActors(movieId);
  }
}
