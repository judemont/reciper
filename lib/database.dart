//import 'dart:js_interop';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recipe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert' as convert;

class DatabaseService {
  static const String databaseName = "reciperDB.sqlite";
  static Database? db;

  static const databaseVersion = 3;
  List<String> tables = ["Recipes"];

  static const secretKey = "2023_PRIVATE_KEY_ENCRYPT_2023";

  static Future<Database> initializeDb() async {
    final databasePath = (await getApplicationDocumentsDirectory()).path;
    final path = join(databasePath, databaseName);
    return db ??
        await openDatabase(
          path,
          version: databaseVersion,
          onCreate: (Database db, int version) async {
            await createTables(db);
          },
          onUpgrade: (db, oldVersion, newVersion) async {
            await updateTables(db, oldVersion, newVersion);
          },
          onOpen: (db) async {
            await openDB(db);
          },
        );
  }

  static openDB(Database db) {
    db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;').then((value) {
      print(value);
    });
  }

  static updateTables(Database db, int oldVersion, int newVersion) {
    print(" DB Version : $newVersion");
    print(oldVersion);
    if (oldVersion < newVersion) {
      if (oldVersion < 2) {
        db.execute("""ALTER TABLE Recipes ADD COLUMN servings TEXT """);
      }
      if (oldVersion < 3) {
        db.execute("""ALTER TABLE Recipes ADD COLUMN source TEXT """);
      }
    }
  }

  static Future<void> createTables(Database database) async {
    await database.execute("""
      CREATE TABLE Recipes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          steps TEXT,
          title TEXT NOT NULL,
          servings TEXT,
          ingredients TEXT,
          source TEXT,
      )
    """);
  }

  static Future<int> createRecipe(Recipe recipe) async {
    print("CREATE");

    final db = await DatabaseService.initializeDb();

    final id = await db.insert(
        'Recipes',
        Recipe(
                steps: recipe.steps,
                title: recipe.title,
                ingredients: recipe.ingredients,
                servings: recipe.servings,
                source: recipe.source)
            .toMap());
    return id;
  }

  static Future<List<Recipe>> getRecipes({String searchQuery = ""}) async {
    final db = await DatabaseService.initializeDb();

    final List<Map<String, dynamic>> queryResult =
        await db.query('Recipes', where: "title LIKE '%$searchQuery%'");

    return queryResult.map((e) => Recipe.fromMap(e)).toList();
  }

  static Future<Recipe> getRecipe(int id) async {
    final db = await DatabaseService.initializeDb();

    final List<Map<String, Object?>> queryResult =
        await db.query('Recipes', where: "id = $id");

    return Recipe(
      id: queryResult[0]["id"] as int,
      steps: queryResult[0]["steps"] as String?,
      title: queryResult[0]["title"] as String?,
      ingredients: queryResult[0]["ingredients"] as String?,
      source: queryResult[0]["source"] as String?,
    );
  }

  static Future<void> removeRecipe(int recipeId) async {
    final db = await DatabaseService.initializeDb();
    db.delete("Recipes", where: "id = $recipeId");
  }

  static Future<void> updateRecipe(Recipe recipe) async {
    print("UPDATE");

    final db = await DatabaseService.initializeDb();
    db.update("Recipes", recipe.toMap(),
        where: 'id = ?', whereArgs: [recipe.id]);
  }

  Future<String> export({bool isEncrypted = false}) async {
    print('GENERATE BACKUP');

    var dbs = await DatabaseService.initializeDb();

    List data = [];

    List<Map<String, dynamic>> listMaps = [];

    for (var i = 0; i < tables.length; i++) {
      listMaps = await dbs.query(tables[i]);

      data.add(listMaps);
    }

    List backups = [tables, data];

    String json = convert.jsonEncode(backups);

    if (isEncrypted) {
      var key = encrypt.Key.fromUtf8(secretKey);
      var iv = encrypt.IV.fromLength(16);
      var encrypter = encrypt.Encrypter(encrypt.AES(key));
      var encrypted = encrypter.encrypt(json, iv: iv);

      return encrypted.base64;
    } else {
      return json;
    }
  }

  Future<void> import(String backup, {bool isEncrypted = false}) async {
    print("IIIIIIIMMMMPOOORT");
    var dbs = await DatabaseService.initializeDb();

    Batch batch = dbs.batch();

    var key = encrypt.Key.fromUtf8(secretKey);
    var iv = encrypt.IV.fromLength(16);
    var encrypter = encrypt.Encrypter(encrypt.AES(key));

    List json = convert
        .jsonDecode(isEncrypted ? encrypter.decrypt64(backup, iv: iv) : backup);

    List<Recipe> actualRecipes = await DatabaseService.getRecipes();

    for (var i = 0; i < json[0].length; i++) {
      for (var k = 0; k < json[1][i].length; k++) {
        if (actualRecipes
            .where((recipe) => recipe.title == json[1][i][k]["title"])
            .isEmpty) {
          json[1][i][k]["id"] = null;
          batch.insert(json[0][i], json[1][i][k]);
        }
      }
    }

    await batch.commit(continueOnError: false, noResult: true);

    print('RESTORE BACKUP');
  }
}
