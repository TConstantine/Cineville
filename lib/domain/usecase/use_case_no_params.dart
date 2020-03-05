import 'package:cineville/domain/error/failure/failure.dart';
import 'package:dartz/dartz.dart';

abstract class UseCaseNoParams<E> {
  Future<Either<Failure, E>> execute();
}
