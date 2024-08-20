import 'package:flutter/material.dart';
import 'package:flutter_favorite_places/api/api_helper.dart';
import 'package:flutter_favorite_places/models/place.dart';
import 'package:flutter_favorite_places/screens/maps_screen.dart';

class PlaceDetail extends StatelessWidget {
  const PlaceDetail({super.key, required this.placeModel});

  final PlaceModel placeModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(placeModel.title),
      ),
      body: Stack(
        children: [
          Image.file(
            placeModel.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => MapsScreen(
                          location: placeModel.placeLocation,
                          isSelecting: false,
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(ApiHelper().getMap(
                        placeModel.placeLocation.lat,
                        placeModel.placeLocation.lng)),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Text(
                    placeModel.placeLocation.address,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
