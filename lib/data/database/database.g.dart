// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class ActorEntry extends DataClass implements Insertable<ActorEntry> {
  final int movieId;
  final int id;
  final String name;
  final String profileUrl;
  final String character;
  final int displayOrder;
  ActorEntry(
      {@required this.movieId,
      @required this.id,
      @required this.name,
      @required this.profileUrl,
      @required this.character,
      @required this.displayOrder});
  factory ActorEntry.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return ActorEntry(
      movieId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}movie_id']),
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      profileUrl: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}profile_url']),
      character: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}character']),
      displayOrder: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}display_order']),
    );
  }
  factory ActorEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return ActorEntry(
      movieId: serializer.fromJson<int>(json['movieId']),
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      profileUrl: serializer.fromJson<String>(json['profileUrl']),
      character: serializer.fromJson<String>(json['character']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'movieId': serializer.toJson<int>(movieId),
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'profileUrl': serializer.toJson<String>(profileUrl),
      'character': serializer.toJson<String>(character),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  @override
  ActorEntriesCompanion createCompanion(bool nullToAbsent) {
    return ActorEntriesCompanion(
      movieId: movieId == null && nullToAbsent
          ? const Value.absent()
          : Value(movieId),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      profileUrl: profileUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(profileUrl),
      character: character == null && nullToAbsent
          ? const Value.absent()
          : Value(character),
      displayOrder: displayOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(displayOrder),
    );
  }

  ActorEntry copyWith(
          {int movieId,
          int id,
          String name,
          String profileUrl,
          String character,
          int displayOrder}) =>
      ActorEntry(
        movieId: movieId ?? this.movieId,
        id: id ?? this.id,
        name: name ?? this.name,
        profileUrl: profileUrl ?? this.profileUrl,
        character: character ?? this.character,
        displayOrder: displayOrder ?? this.displayOrder,
      );
  @override
  String toString() {
    return (StringBuffer('ActorEntry(')
          ..write('movieId: $movieId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('profileUrl: $profileUrl, ')
          ..write('character: $character, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      movieId.hashCode,
      $mrjc(
          id.hashCode,
          $mrjc(
              name.hashCode,
              $mrjc(profileUrl.hashCode,
                  $mrjc(character.hashCode, displayOrder.hashCode))))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is ActorEntry &&
          other.movieId == this.movieId &&
          other.id == this.id &&
          other.name == this.name &&
          other.profileUrl == this.profileUrl &&
          other.character == this.character &&
          other.displayOrder == this.displayOrder);
}

class ActorEntriesCompanion extends UpdateCompanion<ActorEntry> {
  final Value<int> movieId;
  final Value<int> id;
  final Value<String> name;
  final Value<String> profileUrl;
  final Value<String> character;
  final Value<int> displayOrder;
  const ActorEntriesCompanion({
    this.movieId = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.profileUrl = const Value.absent(),
    this.character = const Value.absent(),
    this.displayOrder = const Value.absent(),
  });
  ActorEntriesCompanion.insert({
    @required int movieId,
    @required int id,
    @required String name,
    @required String profileUrl,
    @required String character,
    @required int displayOrder,
  })  : movieId = Value(movieId),
        id = Value(id),
        name = Value(name),
        profileUrl = Value(profileUrl),
        character = Value(character),
        displayOrder = Value(displayOrder);
  ActorEntriesCompanion copyWith(
      {Value<int> movieId,
      Value<int> id,
      Value<String> name,
      Value<String> profileUrl,
      Value<String> character,
      Value<int> displayOrder}) {
    return ActorEntriesCompanion(
      movieId: movieId ?? this.movieId,
      id: id ?? this.id,
      name: name ?? this.name,
      profileUrl: profileUrl ?? this.profileUrl,
      character: character ?? this.character,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }
}

class $ActorEntriesTable extends ActorEntries
    with TableInfo<$ActorEntriesTable, ActorEntry> {
  final GeneratedDatabase _db;
  final String _alias;
  $ActorEntriesTable(this._db, [this._alias]);
  final VerificationMeta _movieIdMeta = const VerificationMeta('movieId');
  GeneratedIntColumn _movieId;
  @override
  GeneratedIntColumn get movieId => _movieId ??= _constructMovieId();
  GeneratedIntColumn _constructMovieId() {
    return GeneratedIntColumn('movie_id', $tableName, false,
        $customConstraints: 'REFERENCES MovieEntries(id)');
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _profileUrlMeta = const VerificationMeta('profileUrl');
  GeneratedTextColumn _profileUrl;
  @override
  GeneratedTextColumn get profileUrl => _profileUrl ??= _constructProfileUrl();
  GeneratedTextColumn _constructProfileUrl() {
    return GeneratedTextColumn(
      'profile_url',
      $tableName,
      false,
    );
  }

  final VerificationMeta _characterMeta = const VerificationMeta('character');
  GeneratedTextColumn _character;
  @override
  GeneratedTextColumn get character => _character ??= _constructCharacter();
  GeneratedTextColumn _constructCharacter() {
    return GeneratedTextColumn(
      'character',
      $tableName,
      false,
    );
  }

  final VerificationMeta _displayOrderMeta =
      const VerificationMeta('displayOrder');
  GeneratedIntColumn _displayOrder;
  @override
  GeneratedIntColumn get displayOrder =>
      _displayOrder ??= _constructDisplayOrder();
  GeneratedIntColumn _constructDisplayOrder() {
    return GeneratedIntColumn(
      'display_order',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [movieId, id, name, profileUrl, character, displayOrder];
  @override
  $ActorEntriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'actor_entries';
  @override
  final String actualTableName = 'actor_entries';
  @override
  VerificationContext validateIntegrity(ActorEntriesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.movieId.present) {
      context.handle(_movieIdMeta,
          movieId.isAcceptableValue(d.movieId.value, _movieIdMeta));
    } else if (movieId.isRequired && isInserting) {
      context.missing(_movieIdMeta);
    }
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    if (d.profileUrl.present) {
      context.handle(_profileUrlMeta,
          profileUrl.isAcceptableValue(d.profileUrl.value, _profileUrlMeta));
    } else if (profileUrl.isRequired && isInserting) {
      context.missing(_profileUrlMeta);
    }
    if (d.character.present) {
      context.handle(_characterMeta,
          character.isAcceptableValue(d.character.value, _characterMeta));
    } else if (character.isRequired && isInserting) {
      context.missing(_characterMeta);
    }
    if (d.displayOrder.present) {
      context.handle(
          _displayOrderMeta,
          displayOrder.isAcceptableValue(
              d.displayOrder.value, _displayOrderMeta));
    } else if (displayOrder.isRequired && isInserting) {
      context.missing(_displayOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {movieId, id};
  @override
  ActorEntry map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ActorEntry.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ActorEntriesCompanion d) {
    final map = <String, Variable>{};
    if (d.movieId.present) {
      map['movie_id'] = Variable<int, IntType>(d.movieId.value);
    }
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.profileUrl.present) {
      map['profile_url'] = Variable<String, StringType>(d.profileUrl.value);
    }
    if (d.character.present) {
      map['character'] = Variable<String, StringType>(d.character.value);
    }
    if (d.displayOrder.present) {
      map['display_order'] = Variable<int, IntType>(d.displayOrder.value);
    }
    return map;
  }

  @override
  $ActorEntriesTable createAlias(String alias) {
    return $ActorEntriesTable(_db, alias);
  }
}

class GenreEntry extends DataClass implements Insertable<GenreEntry> {
  final int id;
  final String name;
  GenreEntry({@required this.id, @required this.name});
  factory GenreEntry.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return GenreEntry(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  factory GenreEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return GenreEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  @override
  GenreEntriesCompanion createCompanion(bool nullToAbsent) {
    return GenreEntriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  GenreEntry copyWith({int id, String name}) => GenreEntry(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('GenreEntry(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, name.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is GenreEntry && other.id == this.id && other.name == this.name);
}

class GenreEntriesCompanion extends UpdateCompanion<GenreEntry> {
  final Value<int> id;
  final Value<String> name;
  const GenreEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  GenreEntriesCompanion.insert({
    @required int id,
    @required String name,
  })  : id = Value(id),
        name = Value(name);
  GenreEntriesCompanion copyWith({Value<int> id, Value<String> name}) {
    return GenreEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

class $GenreEntriesTable extends GenreEntries
    with TableInfo<$GenreEntriesTable, GenreEntry> {
  final GeneratedDatabase _db;
  final String _alias;
  $GenreEntriesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  $GenreEntriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'genre_entries';
  @override
  final String actualTableName = 'genre_entries';
  @override
  VerificationContext validateIntegrity(GenreEntriesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, name};
  @override
  GenreEntry map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return GenreEntry.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(GenreEntriesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    return map;
  }

  @override
  $GenreEntriesTable createAlias(String alias) {
    return $GenreEntriesTable(_db, alias);
  }
}

class MovieEntry extends DataClass implements Insertable<MovieEntry> {
  final int id;
  final String title;
  final String plotSynopsis;
  final String genreIds;
  final double rating;
  final String posterUrl;
  final String backdropUrl;
  final String releaseDate;
  final String languageCode;
  final double popularity;
  MovieEntry(
      {@required this.id,
      @required this.title,
      @required this.plotSynopsis,
      @required this.genreIds,
      @required this.rating,
      @required this.posterUrl,
      @required this.backdropUrl,
      @required this.releaseDate,
      @required this.languageCode,
      @required this.popularity});
  factory MovieEntry.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    return MovieEntry(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      plotSynopsis: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}plot_synopsis']),
      genreIds: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}genre_ids']),
      rating:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}rating']),
      posterUrl: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}poster_url']),
      backdropUrl: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}backdrop_url']),
      releaseDate: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}release_date']),
      languageCode: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}language_code']),
      popularity: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}popularity']),
    );
  }
  factory MovieEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return MovieEntry(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      plotSynopsis: serializer.fromJson<String>(json['plotSynopsis']),
      genreIds: serializer.fromJson<String>(json['genreIds']),
      rating: serializer.fromJson<double>(json['rating']),
      posterUrl: serializer.fromJson<String>(json['posterUrl']),
      backdropUrl: serializer.fromJson<String>(json['backdropUrl']),
      releaseDate: serializer.fromJson<String>(json['releaseDate']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      popularity: serializer.fromJson<double>(json['popularity']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'plotSynopsis': serializer.toJson<String>(plotSynopsis),
      'genreIds': serializer.toJson<String>(genreIds),
      'rating': serializer.toJson<double>(rating),
      'posterUrl': serializer.toJson<String>(posterUrl),
      'backdropUrl': serializer.toJson<String>(backdropUrl),
      'releaseDate': serializer.toJson<String>(releaseDate),
      'languageCode': serializer.toJson<String>(languageCode),
      'popularity': serializer.toJson<double>(popularity),
    };
  }

  @override
  MovieEntriesCompanion createCompanion(bool nullToAbsent) {
    return MovieEntriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      plotSynopsis: plotSynopsis == null && nullToAbsent
          ? const Value.absent()
          : Value(plotSynopsis),
      genreIds: genreIds == null && nullToAbsent
          ? const Value.absent()
          : Value(genreIds),
      rating:
          rating == null && nullToAbsent ? const Value.absent() : Value(rating),
      posterUrl: posterUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(posterUrl),
      backdropUrl: backdropUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(backdropUrl),
      releaseDate: releaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseDate),
      languageCode: languageCode == null && nullToAbsent
          ? const Value.absent()
          : Value(languageCode),
      popularity: popularity == null && nullToAbsent
          ? const Value.absent()
          : Value(popularity),
    );
  }

  MovieEntry copyWith(
          {int id,
          String title,
          String plotSynopsis,
          String genreIds,
          double rating,
          String posterUrl,
          String backdropUrl,
          String releaseDate,
          String languageCode,
          double popularity}) =>
      MovieEntry(
        id: id ?? this.id,
        title: title ?? this.title,
        plotSynopsis: plotSynopsis ?? this.plotSynopsis,
        genreIds: genreIds ?? this.genreIds,
        rating: rating ?? this.rating,
        posterUrl: posterUrl ?? this.posterUrl,
        backdropUrl: backdropUrl ?? this.backdropUrl,
        releaseDate: releaseDate ?? this.releaseDate,
        languageCode: languageCode ?? this.languageCode,
        popularity: popularity ?? this.popularity,
      );
  @override
  String toString() {
    return (StringBuffer('MovieEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('plotSynopsis: $plotSynopsis, ')
          ..write('genreIds: $genreIds, ')
          ..write('rating: $rating, ')
          ..write('posterUrl: $posterUrl, ')
          ..write('backdropUrl: $backdropUrl, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('languageCode: $languageCode, ')
          ..write('popularity: $popularity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          title.hashCode,
          $mrjc(
              plotSynopsis.hashCode,
              $mrjc(
                  genreIds.hashCode,
                  $mrjc(
                      rating.hashCode,
                      $mrjc(
                          posterUrl.hashCode,
                          $mrjc(
                              backdropUrl.hashCode,
                              $mrjc(
                                  releaseDate.hashCode,
                                  $mrjc(languageCode.hashCode,
                                      popularity.hashCode))))))))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is MovieEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.plotSynopsis == this.plotSynopsis &&
          other.genreIds == this.genreIds &&
          other.rating == this.rating &&
          other.posterUrl == this.posterUrl &&
          other.backdropUrl == this.backdropUrl &&
          other.releaseDate == this.releaseDate &&
          other.languageCode == this.languageCode &&
          other.popularity == this.popularity);
}

class MovieEntriesCompanion extends UpdateCompanion<MovieEntry> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> plotSynopsis;
  final Value<String> genreIds;
  final Value<double> rating;
  final Value<String> posterUrl;
  final Value<String> backdropUrl;
  final Value<String> releaseDate;
  final Value<String> languageCode;
  final Value<double> popularity;
  const MovieEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.plotSynopsis = const Value.absent(),
    this.genreIds = const Value.absent(),
    this.rating = const Value.absent(),
    this.posterUrl = const Value.absent(),
    this.backdropUrl = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.popularity = const Value.absent(),
  });
  MovieEntriesCompanion.insert({
    @required int id,
    @required String title,
    @required String plotSynopsis,
    @required String genreIds,
    @required double rating,
    @required String posterUrl,
    @required String backdropUrl,
    @required String releaseDate,
    @required String languageCode,
    @required double popularity,
  })  : id = Value(id),
        title = Value(title),
        plotSynopsis = Value(plotSynopsis),
        genreIds = Value(genreIds),
        rating = Value(rating),
        posterUrl = Value(posterUrl),
        backdropUrl = Value(backdropUrl),
        releaseDate = Value(releaseDate),
        languageCode = Value(languageCode),
        popularity = Value(popularity);
  MovieEntriesCompanion copyWith(
      {Value<int> id,
      Value<String> title,
      Value<String> plotSynopsis,
      Value<String> genreIds,
      Value<double> rating,
      Value<String> posterUrl,
      Value<String> backdropUrl,
      Value<String> releaseDate,
      Value<String> languageCode,
      Value<double> popularity}) {
    return MovieEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      plotSynopsis: plotSynopsis ?? this.plotSynopsis,
      genreIds: genreIds ?? this.genreIds,
      rating: rating ?? this.rating,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      releaseDate: releaseDate ?? this.releaseDate,
      languageCode: languageCode ?? this.languageCode,
      popularity: popularity ?? this.popularity,
    );
  }
}

class $MovieEntriesTable extends MovieEntries
    with TableInfo<$MovieEntriesTable, MovieEntry> {
  final GeneratedDatabase _db;
  final String _alias;
  $MovieEntriesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _plotSynopsisMeta =
      const VerificationMeta('plotSynopsis');
  GeneratedTextColumn _plotSynopsis;
  @override
  GeneratedTextColumn get plotSynopsis =>
      _plotSynopsis ??= _constructPlotSynopsis();
  GeneratedTextColumn _constructPlotSynopsis() {
    return GeneratedTextColumn(
      'plot_synopsis',
      $tableName,
      false,
    );
  }

  final VerificationMeta _genreIdsMeta = const VerificationMeta('genreIds');
  GeneratedTextColumn _genreIds;
  @override
  GeneratedTextColumn get genreIds => _genreIds ??= _constructGenreIds();
  GeneratedTextColumn _constructGenreIds() {
    return GeneratedTextColumn(
      'genre_ids',
      $tableName,
      false,
    );
  }

  final VerificationMeta _ratingMeta = const VerificationMeta('rating');
  GeneratedRealColumn _rating;
  @override
  GeneratedRealColumn get rating => _rating ??= _constructRating();
  GeneratedRealColumn _constructRating() {
    return GeneratedRealColumn(
      'rating',
      $tableName,
      false,
    );
  }

  final VerificationMeta _posterUrlMeta = const VerificationMeta('posterUrl');
  GeneratedTextColumn _posterUrl;
  @override
  GeneratedTextColumn get posterUrl => _posterUrl ??= _constructPosterUrl();
  GeneratedTextColumn _constructPosterUrl() {
    return GeneratedTextColumn(
      'poster_url',
      $tableName,
      false,
    );
  }

  final VerificationMeta _backdropUrlMeta =
      const VerificationMeta('backdropUrl');
  GeneratedTextColumn _backdropUrl;
  @override
  GeneratedTextColumn get backdropUrl =>
      _backdropUrl ??= _constructBackdropUrl();
  GeneratedTextColumn _constructBackdropUrl() {
    return GeneratedTextColumn(
      'backdrop_url',
      $tableName,
      false,
    );
  }

  final VerificationMeta _releaseDateMeta =
      const VerificationMeta('releaseDate');
  GeneratedTextColumn _releaseDate;
  @override
  GeneratedTextColumn get releaseDate =>
      _releaseDate ??= _constructReleaseDate();
  GeneratedTextColumn _constructReleaseDate() {
    return GeneratedTextColumn(
      'release_date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _languageCodeMeta =
      const VerificationMeta('languageCode');
  GeneratedTextColumn _languageCode;
  @override
  GeneratedTextColumn get languageCode =>
      _languageCode ??= _constructLanguageCode();
  GeneratedTextColumn _constructLanguageCode() {
    return GeneratedTextColumn(
      'language_code',
      $tableName,
      false,
    );
  }

  final VerificationMeta _popularityMeta = const VerificationMeta('popularity');
  GeneratedRealColumn _popularity;
  @override
  GeneratedRealColumn get popularity => _popularity ??= _constructPopularity();
  GeneratedRealColumn _constructPopularity() {
    return GeneratedRealColumn(
      'popularity',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        plotSynopsis,
        genreIds,
        rating,
        posterUrl,
        backdropUrl,
        releaseDate,
        languageCode,
        popularity
      ];
  @override
  $MovieEntriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'movie_entries';
  @override
  final String actualTableName = 'movie_entries';
  @override
  VerificationContext validateIntegrity(MovieEntriesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.title.present) {
      context.handle(
          _titleMeta, title.isAcceptableValue(d.title.value, _titleMeta));
    } else if (title.isRequired && isInserting) {
      context.missing(_titleMeta);
    }
    if (d.plotSynopsis.present) {
      context.handle(
          _plotSynopsisMeta,
          plotSynopsis.isAcceptableValue(
              d.plotSynopsis.value, _plotSynopsisMeta));
    } else if (plotSynopsis.isRequired && isInserting) {
      context.missing(_plotSynopsisMeta);
    }
    if (d.genreIds.present) {
      context.handle(_genreIdsMeta,
          genreIds.isAcceptableValue(d.genreIds.value, _genreIdsMeta));
    } else if (genreIds.isRequired && isInserting) {
      context.missing(_genreIdsMeta);
    }
    if (d.rating.present) {
      context.handle(
          _ratingMeta, rating.isAcceptableValue(d.rating.value, _ratingMeta));
    } else if (rating.isRequired && isInserting) {
      context.missing(_ratingMeta);
    }
    if (d.posterUrl.present) {
      context.handle(_posterUrlMeta,
          posterUrl.isAcceptableValue(d.posterUrl.value, _posterUrlMeta));
    } else if (posterUrl.isRequired && isInserting) {
      context.missing(_posterUrlMeta);
    }
    if (d.backdropUrl.present) {
      context.handle(_backdropUrlMeta,
          backdropUrl.isAcceptableValue(d.backdropUrl.value, _backdropUrlMeta));
    } else if (backdropUrl.isRequired && isInserting) {
      context.missing(_backdropUrlMeta);
    }
    if (d.releaseDate.present) {
      context.handle(_releaseDateMeta,
          releaseDate.isAcceptableValue(d.releaseDate.value, _releaseDateMeta));
    } else if (releaseDate.isRequired && isInserting) {
      context.missing(_releaseDateMeta);
    }
    if (d.languageCode.present) {
      context.handle(
          _languageCodeMeta,
          languageCode.isAcceptableValue(
              d.languageCode.value, _languageCodeMeta));
    } else if (languageCode.isRequired && isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (d.popularity.present) {
      context.handle(_popularityMeta,
          popularity.isAcceptableValue(d.popularity.value, _popularityMeta));
    } else if (popularity.isRequired && isInserting) {
      context.missing(_popularityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MovieEntry map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return MovieEntry.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(MovieEntriesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.title.present) {
      map['title'] = Variable<String, StringType>(d.title.value);
    }
    if (d.plotSynopsis.present) {
      map['plot_synopsis'] = Variable<String, StringType>(d.plotSynopsis.value);
    }
    if (d.genreIds.present) {
      map['genre_ids'] = Variable<String, StringType>(d.genreIds.value);
    }
    if (d.rating.present) {
      map['rating'] = Variable<double, RealType>(d.rating.value);
    }
    if (d.posterUrl.present) {
      map['poster_url'] = Variable<String, StringType>(d.posterUrl.value);
    }
    if (d.backdropUrl.present) {
      map['backdrop_url'] = Variable<String, StringType>(d.backdropUrl.value);
    }
    if (d.releaseDate.present) {
      map['release_date'] = Variable<String, StringType>(d.releaseDate.value);
    }
    if (d.languageCode.present) {
      map['language_code'] = Variable<String, StringType>(d.languageCode.value);
    }
    if (d.popularity.present) {
      map['popularity'] = Variable<double, RealType>(d.popularity.value);
    }
    return map;
  }

  @override
  $MovieEntriesTable createAlias(String alias) {
    return $MovieEntriesTable(_db, alias);
  }
}

class MovieTagEntry extends DataClass implements Insertable<MovieTagEntry> {
  final int movieId;
  final String name;
  MovieTagEntry({@required this.movieId, @required this.name});
  factory MovieTagEntry.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return MovieTagEntry(
      movieId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}movie_id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  factory MovieTagEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return MovieTagEntry(
      movieId: serializer.fromJson<int>(json['movieId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'movieId': serializer.toJson<int>(movieId),
      'name': serializer.toJson<String>(name),
    };
  }

  @override
  MovieTagEntriesCompanion createCompanion(bool nullToAbsent) {
    return MovieTagEntriesCompanion(
      movieId: movieId == null && nullToAbsent
          ? const Value.absent()
          : Value(movieId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  MovieTagEntry copyWith({int movieId, String name}) => MovieTagEntry(
        movieId: movieId ?? this.movieId,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('MovieTagEntry(')
          ..write('movieId: $movieId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(movieId.hashCode, name.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is MovieTagEntry &&
          other.movieId == this.movieId &&
          other.name == this.name);
}

class MovieTagEntriesCompanion extends UpdateCompanion<MovieTagEntry> {
  final Value<int> movieId;
  final Value<String> name;
  const MovieTagEntriesCompanion({
    this.movieId = const Value.absent(),
    this.name = const Value.absent(),
  });
  MovieTagEntriesCompanion.insert({
    @required int movieId,
    @required String name,
  })  : movieId = Value(movieId),
        name = Value(name);
  MovieTagEntriesCompanion copyWith({Value<int> movieId, Value<String> name}) {
    return MovieTagEntriesCompanion(
      movieId: movieId ?? this.movieId,
      name: name ?? this.name,
    );
  }
}

class $MovieTagEntriesTable extends MovieTagEntries
    with TableInfo<$MovieTagEntriesTable, MovieTagEntry> {
  final GeneratedDatabase _db;
  final String _alias;
  $MovieTagEntriesTable(this._db, [this._alias]);
  final VerificationMeta _movieIdMeta = const VerificationMeta('movieId');
  GeneratedIntColumn _movieId;
  @override
  GeneratedIntColumn get movieId => _movieId ??= _constructMovieId();
  GeneratedIntColumn _constructMovieId() {
    return GeneratedIntColumn('movie_id', $tableName, false,
        $customConstraints: 'REFERENCES MovieEntries(id)');
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [movieId, name];
  @override
  $MovieTagEntriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'movie_tag_entries';
  @override
  final String actualTableName = 'movie_tag_entries';
  @override
  VerificationContext validateIntegrity(MovieTagEntriesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.movieId.present) {
      context.handle(_movieIdMeta,
          movieId.isAcceptableValue(d.movieId.value, _movieIdMeta));
    } else if (movieId.isRequired && isInserting) {
      context.missing(_movieIdMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {movieId, name};
  @override
  MovieTagEntry map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return MovieTagEntry.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(MovieTagEntriesCompanion d) {
    final map = <String, Variable>{};
    if (d.movieId.present) {
      map['movie_id'] = Variable<int, IntType>(d.movieId.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    return map;
  }

  @override
  $MovieTagEntriesTable createAlias(String alias) {
    return $MovieTagEntriesTable(_db, alias);
  }
}

class ReviewEntry extends DataClass implements Insertable<ReviewEntry> {
  final int movieId;
  final String author;
  final String content;
  ReviewEntry(
      {@required this.movieId, @required this.author, @required this.content});
  factory ReviewEntry.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return ReviewEntry(
      movieId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}movie_id']),
      author:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}author']),
      content:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}content']),
    );
  }
  factory ReviewEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return ReviewEntry(
      movieId: serializer.fromJson<int>(json['movieId']),
      author: serializer.fromJson<String>(json['author']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'movieId': serializer.toJson<int>(movieId),
      'author': serializer.toJson<String>(author),
      'content': serializer.toJson<String>(content),
    };
  }

  @override
  ReviewEntriesCompanion createCompanion(bool nullToAbsent) {
    return ReviewEntriesCompanion(
      movieId: movieId == null && nullToAbsent
          ? const Value.absent()
          : Value(movieId),
      author:
          author == null && nullToAbsent ? const Value.absent() : Value(author),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
    );
  }

  ReviewEntry copyWith({int movieId, String author, String content}) =>
      ReviewEntry(
        movieId: movieId ?? this.movieId,
        author: author ?? this.author,
        content: content ?? this.content,
      );
  @override
  String toString() {
    return (StringBuffer('ReviewEntry(')
          ..write('movieId: $movieId, ')
          ..write('author: $author, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(movieId.hashCode, $mrjc(author.hashCode, content.hashCode)));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is ReviewEntry &&
          other.movieId == this.movieId &&
          other.author == this.author &&
          other.content == this.content);
}

class ReviewEntriesCompanion extends UpdateCompanion<ReviewEntry> {
  final Value<int> movieId;
  final Value<String> author;
  final Value<String> content;
  const ReviewEntriesCompanion({
    this.movieId = const Value.absent(),
    this.author = const Value.absent(),
    this.content = const Value.absent(),
  });
  ReviewEntriesCompanion.insert({
    @required int movieId,
    @required String author,
    @required String content,
  })  : movieId = Value(movieId),
        author = Value(author),
        content = Value(content);
  ReviewEntriesCompanion copyWith(
      {Value<int> movieId, Value<String> author, Value<String> content}) {
    return ReviewEntriesCompanion(
      movieId: movieId ?? this.movieId,
      author: author ?? this.author,
      content: content ?? this.content,
    );
  }
}

class $ReviewEntriesTable extends ReviewEntries
    with TableInfo<$ReviewEntriesTable, ReviewEntry> {
  final GeneratedDatabase _db;
  final String _alias;
  $ReviewEntriesTable(this._db, [this._alias]);
  final VerificationMeta _movieIdMeta = const VerificationMeta('movieId');
  GeneratedIntColumn _movieId;
  @override
  GeneratedIntColumn get movieId => _movieId ??= _constructMovieId();
  GeneratedIntColumn _constructMovieId() {
    return GeneratedIntColumn('movie_id', $tableName, false,
        $customConstraints: 'REFERENCES MovieEntries(id)');
  }

  final VerificationMeta _authorMeta = const VerificationMeta('author');
  GeneratedTextColumn _author;
  @override
  GeneratedTextColumn get author => _author ??= _constructAuthor();
  GeneratedTextColumn _constructAuthor() {
    return GeneratedTextColumn(
      'author',
      $tableName,
      false,
    );
  }

  final VerificationMeta _contentMeta = const VerificationMeta('content');
  GeneratedTextColumn _content;
  @override
  GeneratedTextColumn get content => _content ??= _constructContent();
  GeneratedTextColumn _constructContent() {
    return GeneratedTextColumn(
      'content',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [movieId, author, content];
  @override
  $ReviewEntriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'review_entries';
  @override
  final String actualTableName = 'review_entries';
  @override
  VerificationContext validateIntegrity(ReviewEntriesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.movieId.present) {
      context.handle(_movieIdMeta,
          movieId.isAcceptableValue(d.movieId.value, _movieIdMeta));
    } else if (movieId.isRequired && isInserting) {
      context.missing(_movieIdMeta);
    }
    if (d.author.present) {
      context.handle(
          _authorMeta, author.isAcceptableValue(d.author.value, _authorMeta));
    } else if (author.isRequired && isInserting) {
      context.missing(_authorMeta);
    }
    if (d.content.present) {
      context.handle(_contentMeta,
          content.isAcceptableValue(d.content.value, _contentMeta));
    } else if (content.isRequired && isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {movieId, author};
  @override
  ReviewEntry map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ReviewEntry.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(ReviewEntriesCompanion d) {
    final map = <String, Variable>{};
    if (d.movieId.present) {
      map['movie_id'] = Variable<int, IntType>(d.movieId.value);
    }
    if (d.author.present) {
      map['author'] = Variable<String, StringType>(d.author.value);
    }
    if (d.content.present) {
      map['content'] = Variable<String, StringType>(d.content.value);
    }
    return map;
  }

  @override
  $ReviewEntriesTable createAlias(String alias) {
    return $ReviewEntriesTable(_db, alias);
  }
}

class SimilarMovieEntry extends DataClass
    implements Insertable<SimilarMovieEntry> {
  final int movieId;
  final int similarMovieId;
  SimilarMovieEntry({@required this.movieId, @required this.similarMovieId});
  factory SimilarMovieEntry.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    return SimilarMovieEntry(
      movieId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}movie_id']),
      similarMovieId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}similar_movie_id']),
    );
  }
  factory SimilarMovieEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return SimilarMovieEntry(
      movieId: serializer.fromJson<int>(json['movieId']),
      similarMovieId: serializer.fromJson<int>(json['similarMovieId']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'movieId': serializer.toJson<int>(movieId),
      'similarMovieId': serializer.toJson<int>(similarMovieId),
    };
  }

  @override
  SimilarMovieEntriesCompanion createCompanion(bool nullToAbsent) {
    return SimilarMovieEntriesCompanion(
      movieId: movieId == null && nullToAbsent
          ? const Value.absent()
          : Value(movieId),
      similarMovieId: similarMovieId == null && nullToAbsent
          ? const Value.absent()
          : Value(similarMovieId),
    );
  }

  SimilarMovieEntry copyWith({int movieId, int similarMovieId}) =>
      SimilarMovieEntry(
        movieId: movieId ?? this.movieId,
        similarMovieId: similarMovieId ?? this.similarMovieId,
      );
  @override
  String toString() {
    return (StringBuffer('SimilarMovieEntry(')
          ..write('movieId: $movieId, ')
          ..write('similarMovieId: $similarMovieId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(movieId.hashCode, similarMovieId.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is SimilarMovieEntry &&
          other.movieId == this.movieId &&
          other.similarMovieId == this.similarMovieId);
}

class SimilarMovieEntriesCompanion extends UpdateCompanion<SimilarMovieEntry> {
  final Value<int> movieId;
  final Value<int> similarMovieId;
  const SimilarMovieEntriesCompanion({
    this.movieId = const Value.absent(),
    this.similarMovieId = const Value.absent(),
  });
  SimilarMovieEntriesCompanion.insert({
    @required int movieId,
    @required int similarMovieId,
  })  : movieId = Value(movieId),
        similarMovieId = Value(similarMovieId);
  SimilarMovieEntriesCompanion copyWith(
      {Value<int> movieId, Value<int> similarMovieId}) {
    return SimilarMovieEntriesCompanion(
      movieId: movieId ?? this.movieId,
      similarMovieId: similarMovieId ?? this.similarMovieId,
    );
  }
}

class $SimilarMovieEntriesTable extends SimilarMovieEntries
    with TableInfo<$SimilarMovieEntriesTable, SimilarMovieEntry> {
  final GeneratedDatabase _db;
  final String _alias;
  $SimilarMovieEntriesTable(this._db, [this._alias]);
  final VerificationMeta _movieIdMeta = const VerificationMeta('movieId');
  GeneratedIntColumn _movieId;
  @override
  GeneratedIntColumn get movieId => _movieId ??= _constructMovieId();
  GeneratedIntColumn _constructMovieId() {
    return GeneratedIntColumn('movie_id', $tableName, false,
        $customConstraints: 'REFERENCES MovieEntries(id)');
  }

  final VerificationMeta _similarMovieIdMeta =
      const VerificationMeta('similarMovieId');
  GeneratedIntColumn _similarMovieId;
  @override
  GeneratedIntColumn get similarMovieId =>
      _similarMovieId ??= _constructSimilarMovieId();
  GeneratedIntColumn _constructSimilarMovieId() {
    return GeneratedIntColumn('similar_movie_id', $tableName, false,
        $customConstraints: 'REFERENCES MovieEntries(id)');
  }

  @override
  List<GeneratedColumn> get $columns => [movieId, similarMovieId];
  @override
  $SimilarMovieEntriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'similar_movie_entries';
  @override
  final String actualTableName = 'similar_movie_entries';
  @override
  VerificationContext validateIntegrity(SimilarMovieEntriesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.movieId.present) {
      context.handle(_movieIdMeta,
          movieId.isAcceptableValue(d.movieId.value, _movieIdMeta));
    } else if (movieId.isRequired && isInserting) {
      context.missing(_movieIdMeta);
    }
    if (d.similarMovieId.present) {
      context.handle(
          _similarMovieIdMeta,
          similarMovieId.isAcceptableValue(
              d.similarMovieId.value, _similarMovieIdMeta));
    } else if (similarMovieId.isRequired && isInserting) {
      context.missing(_similarMovieIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {movieId, similarMovieId};
  @override
  SimilarMovieEntry map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return SimilarMovieEntry.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(SimilarMovieEntriesCompanion d) {
    final map = <String, Variable>{};
    if (d.movieId.present) {
      map['movie_id'] = Variable<int, IntType>(d.movieId.value);
    }
    if (d.similarMovieId.present) {
      map['similar_movie_id'] = Variable<int, IntType>(d.similarMovieId.value);
    }
    return map;
  }

  @override
  $SimilarMovieEntriesTable createAlias(String alias) {
    return $SimilarMovieEntriesTable(_db, alias);
  }
}

class VideoEntry extends DataClass implements Insertable<VideoEntry> {
  final int movieId;
  final String videoId;
  final String key;
  VideoEntry(
      {@required this.movieId, @required this.videoId, @required this.key});
  factory VideoEntry.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return VideoEntry(
      movieId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}movie_id']),
      videoId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}video_id']),
      key: stringType.mapFromDatabaseResponse(data['${effectivePrefix}key']),
    );
  }
  factory VideoEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return VideoEntry(
      movieId: serializer.fromJson<int>(json['movieId']),
      videoId: serializer.fromJson<String>(json['videoId']),
      key: serializer.fromJson<String>(json['key']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'movieId': serializer.toJson<int>(movieId),
      'videoId': serializer.toJson<String>(videoId),
      'key': serializer.toJson<String>(key),
    };
  }

  @override
  VideoEntriesCompanion createCompanion(bool nullToAbsent) {
    return VideoEntriesCompanion(
      movieId: movieId == null && nullToAbsent
          ? const Value.absent()
          : Value(movieId),
      videoId: videoId == null && nullToAbsent
          ? const Value.absent()
          : Value(videoId),
      key: key == null && nullToAbsent ? const Value.absent() : Value(key),
    );
  }

  VideoEntry copyWith({int movieId, String videoId, String key}) => VideoEntry(
        movieId: movieId ?? this.movieId,
        videoId: videoId ?? this.videoId,
        key: key ?? this.key,
      );
  @override
  String toString() {
    return (StringBuffer('VideoEntry(')
          ..write('movieId: $movieId, ')
          ..write('videoId: $videoId, ')
          ..write('key: $key')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(movieId.hashCode, $mrjc(videoId.hashCode, key.hashCode)));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is VideoEntry &&
          other.movieId == this.movieId &&
          other.videoId == this.videoId &&
          other.key == this.key);
}

class VideoEntriesCompanion extends UpdateCompanion<VideoEntry> {
  final Value<int> movieId;
  final Value<String> videoId;
  final Value<String> key;
  const VideoEntriesCompanion({
    this.movieId = const Value.absent(),
    this.videoId = const Value.absent(),
    this.key = const Value.absent(),
  });
  VideoEntriesCompanion.insert({
    @required int movieId,
    @required String videoId,
    @required String key,
  })  : movieId = Value(movieId),
        videoId = Value(videoId),
        key = Value(key);
  VideoEntriesCompanion copyWith(
      {Value<int> movieId, Value<String> videoId, Value<String> key}) {
    return VideoEntriesCompanion(
      movieId: movieId ?? this.movieId,
      videoId: videoId ?? this.videoId,
      key: key ?? this.key,
    );
  }
}

class $VideoEntriesTable extends VideoEntries
    with TableInfo<$VideoEntriesTable, VideoEntry> {
  final GeneratedDatabase _db;
  final String _alias;
  $VideoEntriesTable(this._db, [this._alias]);
  final VerificationMeta _movieIdMeta = const VerificationMeta('movieId');
  GeneratedIntColumn _movieId;
  @override
  GeneratedIntColumn get movieId => _movieId ??= _constructMovieId();
  GeneratedIntColumn _constructMovieId() {
    return GeneratedIntColumn('movie_id', $tableName, false,
        $customConstraints: 'REFERENCES MovieEntries(id)');
  }

  final VerificationMeta _videoIdMeta = const VerificationMeta('videoId');
  GeneratedTextColumn _videoId;
  @override
  GeneratedTextColumn get videoId => _videoId ??= _constructVideoId();
  GeneratedTextColumn _constructVideoId() {
    return GeneratedTextColumn(
      'video_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _keyMeta = const VerificationMeta('key');
  GeneratedTextColumn _key;
  @override
  GeneratedTextColumn get key => _key ??= _constructKey();
  GeneratedTextColumn _constructKey() {
    return GeneratedTextColumn(
      'key',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [movieId, videoId, key];
  @override
  $VideoEntriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'video_entries';
  @override
  final String actualTableName = 'video_entries';
  @override
  VerificationContext validateIntegrity(VideoEntriesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.movieId.present) {
      context.handle(_movieIdMeta,
          movieId.isAcceptableValue(d.movieId.value, _movieIdMeta));
    } else if (movieId.isRequired && isInserting) {
      context.missing(_movieIdMeta);
    }
    if (d.videoId.present) {
      context.handle(_videoIdMeta,
          videoId.isAcceptableValue(d.videoId.value, _videoIdMeta));
    } else if (videoId.isRequired && isInserting) {
      context.missing(_videoIdMeta);
    }
    if (d.key.present) {
      context.handle(_keyMeta, key.isAcceptableValue(d.key.value, _keyMeta));
    } else if (key.isRequired && isInserting) {
      context.missing(_keyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {movieId, videoId};
  @override
  VideoEntry map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return VideoEntry.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(VideoEntriesCompanion d) {
    final map = <String, Variable>{};
    if (d.movieId.present) {
      map['movie_id'] = Variable<int, IntType>(d.movieId.value);
    }
    if (d.videoId.present) {
      map['video_id'] = Variable<String, StringType>(d.videoId.value);
    }
    if (d.key.present) {
      map['key'] = Variable<String, StringType>(d.key.value);
    }
    return map;
  }

  @override
  $VideoEntriesTable createAlias(String alias) {
    return $VideoEntriesTable(_db, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $ActorEntriesTable _actorEntries;
  $ActorEntriesTable get actorEntries =>
      _actorEntries ??= $ActorEntriesTable(this);
  $GenreEntriesTable _genreEntries;
  $GenreEntriesTable get genreEntries =>
      _genreEntries ??= $GenreEntriesTable(this);
  $MovieEntriesTable _movieEntries;
  $MovieEntriesTable get movieEntries =>
      _movieEntries ??= $MovieEntriesTable(this);
  $MovieTagEntriesTable _movieTagEntries;
  $MovieTagEntriesTable get movieTagEntries =>
      _movieTagEntries ??= $MovieTagEntriesTable(this);
  $ReviewEntriesTable _reviewEntries;
  $ReviewEntriesTable get reviewEntries =>
      _reviewEntries ??= $ReviewEntriesTable(this);
  $SimilarMovieEntriesTable _similarMovieEntries;
  $SimilarMovieEntriesTable get similarMovieEntries =>
      _similarMovieEntries ??= $SimilarMovieEntriesTable(this);
  $VideoEntriesTable _videoEntries;
  $VideoEntriesTable get videoEntries =>
      _videoEntries ??= $VideoEntriesTable(this);
  ActorDao _actorDao;
  ActorDao get actorDao => _actorDao ??= ActorDao(this as Database);
  GenreDao _genreDao;
  GenreDao get genreDao => _genreDao ??= GenreDao(this as Database);
  MovieDao _movieDao;
  MovieDao get movieDao => _movieDao ??= MovieDao(this as Database);
  ReviewDao _reviewDao;
  ReviewDao get reviewDao => _reviewDao ??= ReviewDao(this as Database);
  VideoDao _videoDao;
  VideoDao get videoDao => _videoDao ??= VideoDao(this as Database);
  @override
  List<TableInfo> get allTables => [
        actorEntries,
        genreEntries,
        movieEntries,
        movieTagEntries,
        reviewEntries,
        similarMovieEntries,
        videoEntries
      ];
}
