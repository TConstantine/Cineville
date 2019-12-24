import 'package:cineville/data/datasource/local_data_source.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/data/error/failure/network_failure.dart';
import 'package:cineville/data/error/failure/no_data_failure.dart';
import 'package:cineville/data/error/failure/server_failure.dart';
import 'package:cineville/data/mapper/actor_mapper.dart';
import 'package:cineville/data/model/actor_model.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/actor_repository.dart';
import 'package:dartz/dartz.dart';

class ActorDepository implements ActorRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final Network network;
  final ActorMapper mapper;

  ActorDepository(this.remoteDataSource, this.localDataSource, this.network, this.mapper);

  @override
  Future<Either<Failure, List<Actor>>> getMovieActors(int movieId) async {
    List<ActorModel> actorModels = await localDataSource.getMovieActors(movieId);
    if (actorModels.isEmpty) {
      if (!await network.isConnected()) {
        return Left(NetworkFailure());
      }
      try {
        actorModels = await remoteDataSource.getMovieActors(movieId);
      } on ServerException {
        return Left(ServerFailure());
      }
      if (actorModels.isEmpty) {
        return Left(NoDataFailure());
      }
      localDataSource.storeMovieActors(movieId, actorModels);
    }
    return Right(mapper.map(actorModels));
  }
}
