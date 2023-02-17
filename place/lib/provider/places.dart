import 'package:flutter/material.dart';
import 'dart:io';

import '../model/place.dart';
import '../db/db_access.dart';

class Places with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addData(Place tmp) async {
    _items.add(tmp);
    notifyListeners();
    DB_Access.insertData('places', {
      'id': tmp.id,
      'title': tmp.title,
      'image': tmp.image.path,
      'loc_lat': tmp.location.latitude,
      'loc_lng': tmp.location.longitude,
      'address': tmp.location.address,
    });
  }

  Future<void> getData() async {
    final data = await DB_Access.fetchData('places');
    _items = data
        .map(
          (e) => Place(
            id: e['id'],
            image: File(e['image']),
            title: e['title'],
            location: Location(
              latitude: e['loc_lat'],
              longitude: e['loc_lng'],
              address: e['address'],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }
}
