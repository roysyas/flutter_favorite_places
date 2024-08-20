import 'dart:io';

import 'package:flutter_favorite_places/models/place_location.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceModel {
  PlaceModel({
    required this.title,
    required this.image,
    required this.placeLocation,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final File image;
  final PlaceLocation placeLocation;
}
