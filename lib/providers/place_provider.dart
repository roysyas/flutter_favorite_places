import 'dart:io';

import 'package:flutter_favorite_places/models/place.dart';
import 'package:flutter_favorite_places/models/place_location.dart';
import 'package:flutter_favorite_places/providers/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;

class PlaceNotifier extends StateNotifier<List<PlaceModel>> {
  PlaceNotifier() : super(const []); // initial data

  Future<void> loadPlaces() async {
    state = await DatabaseHelper().loadDb();
  }

  void setPlace(String title, File image, PlaceLocation location) async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');

    final PlaceModel placeModel = PlaceModel(
      title: title,
      image: copiedImage,
      placeLocation: location,
    );

    await DatabaseHelper().insertdb(placeModel);

    state = [
      ...state,
      placeModel,
    ];
  }
}

final placeProvider =
    StateNotifierProvider<PlaceNotifier, List<PlaceModel>>((ref) {
  return PlaceNotifier();
});
