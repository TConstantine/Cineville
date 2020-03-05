import 'package:cineville/data/datasource/database_data_source.dart';
import 'package:cineville/data/datasource/remote_data_source.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:cineville/data/entity/data_entity_type.dart';
import 'package:cineville/data/error/exception/server_exception.dart';
import 'package:cineville/domain/error/failure/network_failure.dart';
import 'package:cineville/domain/error/failure/no_data_failure.dart';
import 'package:cineville/domain/error/failure/server_failure.dart';
import 'package:cineville/data/mapper/actor_domain_entity_mapper.dart';
import 'package:cineville/data/network/network.dart';
import 'package:cineville/domain/entity/actor.dart';
import 'package:cineville/domain/error/failure/failure.dart';
import 'package:cineville/domain/repository/actor_repository.dart';
import 'package:dartz/dartz.dart';

class ActorDepository implements ActorRepository {
  final RemoteDataSource _remoteDataSource;
  final DatabaseDataSource _databaseDataSource;
  final Network _network;
  final ActorDomainEntityMapper _actorDomainEntityMapper;

  ActorDepository(
    this._remoteDataSource,
    this._databaseDataSource,
    this._network,
    this._actorDomainEntityMapper,
  );

  @override
  Future<Either<Failure, List<Actor>>> getMovieActors(int movieId) async {
    List<DataEntity> actorDataEntities = await _databaseDataSource.getMovieDataEntities(
      DataEntityType.ACTOR,
      movieId,
    );
    if (actorDataEntities.isEmpty) {
      if (!await _network.isConnected()) {
        return Left(NetworkFailure());
      }
      try {
        actorDataEntities = await _remoteDataSource.getMovieDataEntities(
          DataEntityType.ACTOR,
          movieId,
        );
      } on ServerException {
        return Left(ServerFailure());
      }
      if (actorDataEntities.isEmpty) {
        return Left(NoDataFailure());
      }
      _databaseDataSource.storeMovieDataEntities(DataEntityType.ACTOR, movieId, actorDataEntities);
    }
    return Right(_actorDomainEntityMapper.map(actorDataEntities));
  }
}
