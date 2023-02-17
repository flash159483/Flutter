import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/place.dart';

class MapScreen extends StatefulWidget {
  final Location userPosition;
  final bool isSelecting;

  MapScreen(
      {this.userPosition =
          const Location(latitude: 37.422, longitude: -122.084),
      this.isSelecting = false});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  void _picklocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google map'),
        actions: [
          if (widget.isSelecting)
            IconButton(
                onPressed: () {
                  _pickedLocation == null
                      ? null
                      : Navigator.of(context).pop(_pickedLocation);
                },
                icon: Icon(Icons.check))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(
                widget.userPosition.latitude, widget.userPosition.longitude),
            zoom: 16),
        onTap: widget.isSelecting ? _picklocation : null,
        markers: (_pickedLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: MarkerId('m1'),
                  position: _pickedLocation ??
                      LatLng(widget.userPosition.latitude,
                          widget.userPosition.longitude),
                ),
              },
      ),
    );
  }
}
