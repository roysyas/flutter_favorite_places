import 'dart:io';

import 'package:flutter_favorite_places/models/place.dart';
import 'package:flutter_favorite_places/models/place_location.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DatabaseHelper {
  final String databaseName = 'places.db';
  final String tableName = 'user_places';
  final String id = 'id';
  final String title = 'title';
  final String image = 'image';
  final String lat = 'lat';
  final String lng = 'lng';
  final String address = 'address';

  Future<Database> getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final database = await sql.openDatabase(
      path.join(dbPath, databaseName),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $tableName($id TEXT PRIMARY KEY, $title TEXT, $image TEXT, $lat REAL, $lng REAL, $address TEXT)');
      },
      version: 1,
    );
    return database;
  }

  Future<void> insertdb(PlaceModel placeModel) async {
    final db = await getDatabase();
    db.insert(
      tableName,
      {
        id: placeModel.id,
        title: placeModel.title,
        image: placeModel.image.path,
        lat: placeModel.placeLocation.lat,
        lng: placeModel.placeLocation.lng,
        address: placeModel.placeLocation.address
      },
    );
  }

  Future<List<PlaceModel>> loadDb() async {
    final db = await getDatabase();
    final data = await db.query(tableName);
    return data
        .map(
          (row) => PlaceModel(
            id: row[id] as String,
            title: row[title] as String,
            image: File(row[image] as String),
            placeLocation: PlaceLocation(
              lat: row[lat] as double,
              lng: row[lng] as double,
              address: row[address] as String,
            ),
          ),
        )
        .toList();
  }
}
