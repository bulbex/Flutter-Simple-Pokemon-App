import 'dart:async';

import 'package:sqflite/sqflite.dart' as sql;

class PokemonDatabaseHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE pokemons(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
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

  static Future<int> insertPokemon(String name, String photo, List<String> types, int weight, int height) async {
    final db = await PokemonDatabaseHelper.db();

    final data = {
      'name': name, 
      'photo': photo, 
      'types': types.join(","), 
      'weight': weight, 
      'height': height
    };

    final id = await db.insert(
      'pokemons',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace
    );

    return id;
  }

  static Future<List<Map<String, dynamic>>> getPokemonsName() async {
    final db = await PokemonDatabaseHelper.db();
    return db.query('pokemons', columns: ['name'], orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getPokemon(String name) async {
    final db = await PokemonDatabaseHelper.db();
    return db.query(
      'pokemons', 
      columns: ['name'],
      where: 'name = $name'
    );
  }
}