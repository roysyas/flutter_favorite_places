import 'package:flutter/material.dart';
import 'package:flutter_favorite_places/models/place.dart';
import 'package:flutter_favorite_places/screens/place_detail.dart';
import 'package:flutter_favorite_places/widgets/place_item.dart';

class PlaceList extends StatelessWidget {
  const PlaceList({super.key, required this.places});

  final List<PlaceModel> places;

  void _onSelect(BuildContext context, PlaceModel place) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PlaceDetail(
          placeModel: place,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'empty list',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) => PlaceItem(
        placeModel: places[index],
        onSelect: (placeModel) {
          _onSelect(context, placeModel);
        },
      ),
    );
  }
}
