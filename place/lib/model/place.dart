import 'package:flutter/foundation.dart';

import 'dart:io';

class Location {
  final double latitude;
  final double longitude;
  final String address;

  const Location({
    @required this.latitude,
    this.address,
    @required this.longitude,
  });
}

class Place {
  final String id;
  final String title;
  final File image;
  final Location location;

  Place({
    @required this.id,
    @required this.title,
    @required this.image,
    @required this.location,
  });
}
