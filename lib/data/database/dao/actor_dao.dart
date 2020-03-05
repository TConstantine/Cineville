import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/database/table/actor_entries.dart';
import 'package:cineville/data/entity/actor_data_entity.dart';
import 'package:cineville/data/entity/data_entity.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'actor_dao.g.dart';

@UseDao(tables: [ActorEntries])
class ActorDao extends DatabaseAccessor<Database> with _$ActorDaoMixin {
  final Database database;

  ActorDao(this.database) : super(database);

  Future<List<DataEntity>> getMovieActors(int movieId) {
    return (select(actorEntries)
          ..where((table) => table.movieId.equals(movieId))
          ..orderBy([(table) => OrderingTerm(expression: table.displayOrder)]))
        .map((actorEntry) => ActorDataEntity(
              id: actorEntry.id,
              name: actorEntry.name,
              profileImage: actorEntry.profileUrl,
              character: actorEntry.character,
              displayOrder: actorEntry.displayOrder,
            ))
        .get();
  }

  Future storeMovieActors(int movieId, List<DataEntity> actorDataEntities) {
    return into(actorEntries).insertAll(
      List<ActorDataEntity>.from(actorDataEntities).map((actorDataEntity) {
        return ActorEntry(
          movieId: movieId,
          id: actorDataEntity.id,
          name: actorDataEntity.name,
          profileUrl: actorDataEntity.profileImage,
          character: actorDataEntity.character,
          displayOrder: actorDataEntity.displayOrder,
        );
      }).toList(),
      orReplace: true,
    );
  }
}
