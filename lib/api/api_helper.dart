import 'dart:convert';

import 'package:flutter_favorite_places/env/env.dart';
import 'package:flutter_favorite_places/models/place_location.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class ApiHelper {
  final String geocodeBaseUrl = 'maps.googleapis.com/maps/api/geocode/';
  final String mapBaseUrl = 'maps.googleapis.com/maps/api/';
  final String apiKey = Env.apiKey;

  Future<String?> getAddress(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey');

    try {
      final response = await http.get(url);
      final resData = json.decode(response.body);
      return resData['results'][0]['formatted_address'];
    } catch (ex) {
      return null;
    }
  }

  String getMap(double lat, double lng) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=$apiKey';
  }

  Future<PlaceLocation?> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;
    PlaceLocation? placeLocation;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    locationData = await location.getLocation();

    if (locationData.latitude != null || locationData.longitude != null) {
      final address = await ApiHelper()
          .getAddress(locationData.latitude!, locationData.longitude!);
      if (address != null) {
        if (address.isNotEmpty) {
          placeLocation = PlaceLocation(
              lat: locationData.latitude!,
              lng: locationData.longitude!,
              address: address);
        }
      }
    }

    return placeLocation;
  }
}
