import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:dartz/dartz.dart';

abstract class ActorRepository {
  Future<Either<Failure, List<Actor>>> getMovieActors(int movieId);
}
