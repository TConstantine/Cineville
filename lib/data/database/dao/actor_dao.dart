import 'package:cineville/data/database/database.dart';
import 'package:cineville/data/database/table/actor_entries.dart';
import 'package:cineville/data/model/actor_model.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'actor_dao.g.dart';

@UseDao(tables: [ActorEntries])
class ActorDao extends DatabaseAccessor<Database> with _$ActorDaoMixin {
  final Database database;

  ActorDao(this.database) : super(database);

  Future<List<ActorModel>> getMovieActors(int movieId) {
    return (select(actorEntries)
          ..where((table) => table.movieId.equals(movieId))
          ..orderBy([(table) => OrderingTerm(expression: table.displayOrder)]))
        .map((actorEntry) => ActorModel(
              id: actorEntry.id,
              name: actorEntry.name,
              profileImage: actorEntry.profileUrl,
              character: actorEntry.character,
              displayOrder: actorEntry.displayOrder,
            ))
        .get();
  }

  Future storeMovieActors(int movieId, List<ActorModel> actorModels) {
    return into(actorEntries).insertAll(
      actorModels.map((actorModel) {
        return ActorEntry(
          movieId: movieId,
          id: actorModel.id,
          name: actorModel.name,
          profileUrl: actorModel.profileImage,
          character: actorModel.character,
          displayOrder: actorModel.displayOrder,
        );
      }).toList(),
      orReplace: true,
    );
  }
}
