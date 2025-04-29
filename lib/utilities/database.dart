import 'dart:convert';

import 'package:reciper/models/tag.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recipe.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static const String databaseName = "reciperDB.sqlite";
  static Database? db;

  static const databaseVersion = 5;
  List<String> tables = ["Recipes", "Tags", "TagsLinks"];

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
      if (oldVersion < 4) {
        db.execute("""
          CREATE TABLE Tags(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT
          )
        """);

        db.execute("""
          CREATE TABLE TagsLinks(
              recipeId INTEGER,
              tagId INTEGER
          )
        """);
      }
      if (oldVersion < 5) {
        db.execute("""ALTER TABLE Recipes ADD COLUMN image BLOB """);
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
          image BLOB
      )
    """);

    await database.execute("""
      CREATE TABLE Tags(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT
      )
    """);
    await database.execute("""
      CREATE TABLE TagsLinks(
          recipeId INTEGER,
          tagId INTEGER
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
                source: recipe.source,
                image: recipe.image)
            .toMap());
    return id;
  }

  static Future<int> createTag(Tag tag) async {
    final db = await DatabaseService.initializeDb();

    final id = await db.insert('Tags', Tag(name: tag.name).toMap());
    return id;
  }

  static Future<int> createTagLink(int tagId, int recipeId) async {
    final db = await DatabaseService.initializeDb();

    final id =
        await db.insert('TagsLinks', {"tagId": tagId, "recipeId": recipeId});
    return id;
  }

  static Future<List<Recipe>> getRecipes({String searchQuery = ""}) async {
    final db = await DatabaseService.initializeDb();

    List<Map<String, dynamic>> queryResult =
        await db.query('Recipes', where: "title LIKE '%$searchQuery%'");

    return queryResult.map((e) => Recipe.fromMap(e)).toList();
  }

  static Future<List<Tag>> getTags() async {
    final db = await DatabaseService.initializeDb();

    List<Map<String, dynamic>> queryResult = await db.query('Tags');

    return queryResult.map((e) => Tag.fromMap(e)).toList();
  }

  static Future<List<Tag>> getTagsFromRecipe(int recipeId) async {
    final db = await DatabaseService.initializeDb();

    List<Map<String, dynamic>> recipeTagsLinks =
        await db.query('TagsLinks', where: "recipeId = $recipeId");

    List<Tag> recipeTags = [];

    for (var tagLink in recipeTagsLinks) {
      List<Map<String, dynamic>> tag =
          await db.query('Tags', where: "id = ${tagLink['tagId']}");

      tag.isNotEmpty ? recipeTags.add(Tag.fromMap(tag[0])) : null;
    }

    return recipeTags;
  }

  static Future<List<Recipe>> getRecipesFromTag(int tagId,
      {String searchQuery = ""}) async {
    final db = await DatabaseService.initializeDb();

    List<Map<String, dynamic>> tagRecipesLinks =
        await db.query('TagsLinks', where: "tagId = $tagId");

    List<Recipe> tagsRecipe = [];

    for (var tagLink in tagRecipesLinks) {
      List<Map<String, dynamic>> recipes = await db.query('Recipes',
          where: "id = ${tagLink['recipeId']} AND title LIKE '%$searchQuery%'");

      recipes.isNotEmpty ? tagsRecipe.add(Recipe.fromMap(recipes[0])) : null;
    }

    return tagsRecipe;
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
      image: queryResult[0]["image"] as String?,
    );
  }

  static Future<void> removeRecipe(int recipeId) async {
    final db = await DatabaseService.initializeDb();
    db.delete("Recipes", where: "id = $recipeId");
  }

  static Future<void> removeTag(int tagId) async {
    final db = await DatabaseService.initializeDb();
    db.delete("Tags", where: "id = $tagId");
  }

  static Future<void> removeTagLink({int? tagId, int? recipeId}) async {
    final db = await DatabaseService.initializeDb();
    db.delete("TagsLinks",
        where: "tagId = ${tagId ?? "tagId"} AND recipeId = ${recipeId ?? "*"}");
  }

  static Future<void> updateRecipe(Recipe recipe) async {
    print("UPDATE");

    final db = await DatabaseService.initializeDb();
    db.update("Recipes", recipe.toMap(),
        where: 'id = ?', whereArgs: [recipe.id]);
  }

  static Future<void> updateTag(Tag tag) async {
    print("UPDATE");

    final db = await DatabaseService.initializeDb();

    db.update("Tags", tag.toMap(), where: 'id = ?', whereArgs: [tag.id]);
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

    String jsonData = jsonEncode(backups);
    print(jsonData);
    return jsonData;
  }

  Future<void> import(String backup) async {
    print(backup);
    var dbs = await DatabaseService.initializeDb();

    Batch batch = dbs.batch();

    List jsonData = jsonDecode(backup);
    print(jsonData);
    List<Recipe> actualRecipes = await DatabaseService.getRecipes();

    for (var i = 0; i < jsonData[0].length; i++) {
      for (var k = 0; k < jsonData[1][i].length; k++) {
        if (actualRecipes
            .where((recipe) => recipe.title == jsonData[1][i][k]["title"])
            .isEmpty) {
          jsonData[1][i][k]["id"] = null;
          batch.insert(jsonData[0][i], jsonData[1][i][k]);
        }
      }
    }

    await batch.commit(continueOnError: false, noResult: true);

    print('RESTORE BACKUP');
  }
}
