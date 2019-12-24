import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/actor_repository.dart';
import 'package:cineville/domain/usecase/use_case.dart';
import 'package:dartz/dartz.dart';

class GetMovieActors implements UseCase<Actor> {
  final ActorRepository repository;

  GetMovieActors(this.repository);

  @override
  Future<Either<Failure, List<Actor>>> execute(int movieId) {
    return repository.getMovieActors(movieId);
  }
}
