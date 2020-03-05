import 'package:cineville/domain/error/failure/failure.dart';
import 'package:dartz/dartz.dart';

abstract class UseCaseWithParams<R, P> {
  Future<Either<Failure, R>> execute(P params);
}
