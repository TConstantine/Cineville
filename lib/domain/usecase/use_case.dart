import 'package:cineville/domain/error/failure/failure.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<E> {
  Future<Either<Failure, List<E>>> execute(int value);
}
