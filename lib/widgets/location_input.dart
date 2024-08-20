import 'package:flutter/material.dart';
import 'package:flutter_favorite_places/api/api_helper.dart';
import 'package:flutter_favorite_places/models/place_location.dart';
import 'package:flutter_favorite_places/screens/maps_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;
  var _isSelectOnMap = false;

  void _getLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    _pickedLocation = await ApiHelper().getCurrentLocation();

    setState(() {
      widget.onSelectLocation(_pickedLocation!);
      _isGettingLocation = false;
    });
  }

  void _selectOnMap() async {
    setState(() {
      _isSelectOnMap = true;
    });

    final defaultLocation = await ApiHelper().getCurrentLocation();
    if (defaultLocation == null) {
      return;
    }

    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => MapsScreen(
          location: defaultLocation,
        ),
      ),
    );

    if (pickedLocation == null) {
      return;
    }

    final address = await ApiHelper()
        .getAddress(pickedLocation.latitude, pickedLocation.longitude);
    if (address != null) {
      setState(() {
        _pickedLocation = PlaceLocation(
            lat: pickedLocation.latitude,
            lng: pickedLocation.longitude,
            address: address);
        widget.onSelectLocation(_pickedLocation!);
        _isSelectOnMap = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'no location',
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onSurface),
      textAlign: TextAlign.center,
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
          ApiHelper().getMap(_pickedLocation!.lat, _pickedLocation!.lng));
    }

    if (_isGettingLocation || _isSelectOnMap) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          )),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _isGettingLocation ? null : _getLocation,
              label: const Text('get current location'),
              icon: const Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: _isSelectOnMap ? null : _selectOnMap,
              label: _isSelectOnMap
                  ? const Text('loading...')
                  : const Text('select on map'),
              icon: _isSelectOnMap
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.map),
            ),
          ],
        ),
      ],
    );
  }
}
