import 'dart:async';

import 'package:sqflite/sqflite.dart' as sql;

class PokemonDatabaseHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE pokemons(
        name TEXT PRIMARY KEY,
        photo TEXT,
        types TEXT,
        weight INTEGER,
        height INTEGER
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'pokemons.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<void> insertPokemon(String name, String photo, List<dynamic> types, int weight, int height) async {
    final db = await PokemonDatabaseHelper.db();

    final data = {
      'name': name, 
      'photo': photo, 
      'types': types.join(","), 
      'weight': weight, 
      'height': height
    };

    await db.insert(
      'pokemons',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace
    );
  }

  static Future<List<Map<String, dynamic>>> getPokemonsName() async {
    final db = await PokemonDatabaseHelper.db();

    return db.query('pokemons', columns: ['name']);
  }

  static Future<List<Map<String, dynamic>>> getPokemon(String name) async {
    final db = await PokemonDatabaseHelper.db();

    return db.query(
      'pokemons',
      where: 'name = ?',
      whereArgs: [name]
    );
  }
}