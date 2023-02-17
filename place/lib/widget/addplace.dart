import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../db/location.dart';
import '../screens/map_screen.dart';

class GetPlace extends StatefulWidget {
  final Function getLoc;

  GetPlace(this.getLoc);
  @override
  State<GetPlace> createState() => _getPlaceState();
}

class _getPlaceState extends State<GetPlace> {
  String _previewImage;

  void setLoc(double lat, double lng) {
    final mapData = LocationDB.generateLocation(latitude: lat, longitude: lng);
    setState(() {
      _previewImage = mapData;
    });
  }

  Future<void> getLocation() async {
    try {
      final locData = await Location().getLocation();
      setLoc(locData.latitude, locData.longitude);
      widget.getLoc(locData.latitude, locData.longitude);
    } catch (error) {
      print(error);
    }
  }

  Future<void> enterMap() async {
    final selectedLocation =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => MapScreen(
        isSelecting: true,
      ),
    ));
    if (selectedLocation == null) {
      return;
    }
    setLoc(selectedLocation.latitude, selectedLocation.longitude);
    widget.getLoc(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImage == null
              ? Text('No place given')
              : Image.network(
                  _previewImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: Icon(Icons.place),
              label: Text('Current Location'),
              onPressed: getLocation,
            ),
            TextButton.icon(
              icon: Icon(Icons.map),
              label: Text('Select Location'),
              onPressed: enterMap,
            ),
          ],
        ),
      ],
    );
  }
}
