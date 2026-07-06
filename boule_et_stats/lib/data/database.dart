// SFD §4 — Modèle de données local (SQLite via drift).
// Rappel : draws.id = UUID stocké en TEXT ; contrainte unique (game, draw_date).

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'database.g.dart';

class Draws extends Table {
  TextColumn get id => text()();
  TextColumn get game => text()();
  DateTimeColumn get drawDate => dateTime()();
  TextColumn get mainNumbers => text().map(const _IntListConverter())();
  TextColumn get bonusNumbers => text().map(const _IntListConverter())();
  IntColumn get jackpotEur => integer().nullable()();
  IntColumn get winnersRank1 => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['UNIQUE (game, draw_date)'];
}

class MyGrids extends Table {
  TextColumn get id => text()();
  TextColumn get game => text()();
  TextColumn get mainNumbers => text().map(const _IntListConverter())();
  TextColumn get bonusNumbers => text().map(const _IntListConverter())();
  TextColumn get strategy => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class _IntListConverter extends TypeConverter<List<int>, String> {
  const _IntListConverter();

  @override
  List<int> fromSql(String fromDb) {
    final decoded = jsonDecode(fromDb) as List<Object?>;
    return decoded.map((e) => e as int).toList(growable: false);
  }

  @override
  String toSql(List<int> value) => jsonEncode(value);
}

@DriftDatabase(tables: [Draws, MyGrids])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'boule_et_stats');
}

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
