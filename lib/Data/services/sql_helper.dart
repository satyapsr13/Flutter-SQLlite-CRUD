import 'dart:developer';

import 'package:flutter_sqllite_impl/Data/model/product_response_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static late final Database database;
  static Future<dynamic> initSQLLiteDB() async {
    database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'sqllite_product_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE product(id INTEGER PRIMARY KEY, title TEXT, slug TEXT,description TEXT, quantity INTEGER,featured_image TEXT, price REAL )',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    // return database;
  }

  Future<bool> insertProduct(Product product) async {
    // Get a reference to the database.
    try {
      final db = await database;

      // await db.close();
      // Insert the Dog into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same dog is inserted twice.
      //
      // In this case, replace any previous data.
      await db.insert(
        'product',
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      log("-------insert error  $e-------------");
      return false;
    }
  }

  Future<List<Product>?> getAllProduct() async {
    // Get a reference to the database.
    try {
      final db = await database;

      // Query the table for all The Dogs.
      final List<Map<String, dynamic>> maps = await db.query('product');

      // Convert the List<Map<String, dynamic> into a List<Dog>.
      return List.generate(maps.length, (i) {
        return Product(
          id: maps[i]['id'],
          title: maps[i]['title'],
          slug: maps[i]['slug'],
          price: maps[i]['price'],
          quantity: maps[i]['quantity'],
          featuredImage: maps[i]['featured_image'],
          description: maps[i]['description'],
        );
      });
    } catch (e) {
      print("SQL_DB_ERROR $e");
      return null;
    }
  }

  Future<void> updateProduct(Product product) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'product',
      product.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [product.id],
    );
  }

  Future<bool> deleteProduct(int id) async {
    try {
      // Get a reference to the database.
      final db = await database;

      // Remove the Dog from the database.
      await db.delete(
        'product',
        // Use a `where` clause to delete a specific dog.
        where: 'id = ?',
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [id],
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
