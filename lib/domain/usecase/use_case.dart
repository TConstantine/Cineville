import 'package:cineville/domain/entity/movie.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase {
  Future<Either<Failure, List<Movie>>> execute(int page);
}
