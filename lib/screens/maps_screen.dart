import 'package:flutter/material.dart';
import 'package:flutter_favorite_places/models/place_location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen(
      {super.key, required this.location, this.isSelecting = true});

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapsScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapsScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick your location' : 'Your location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                if (_pickedLocation != null) {
                  Navigator.of(context).pop(_pickedLocation);
                }
              },
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting
            ? null
            : (position) {
                setState(() {
                  _pickedLocation = position;
                });
              },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.location.lat,
            widget.location.lng,
          ),
          zoom: 16,
        ),
        markers: (_pickedLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pickedLocation ??
                      LatLng(
                        widget.location.lat,
                        widget.location.lng,
                      ),
                ),
              },
      ),
    );
  }
}
