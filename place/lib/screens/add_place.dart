import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/places.dart';
import '../model/place.dart';
import '../widget/addimage.dart';
import '../widget/addplace.dart';
import '../db/location.dart';

class AddPlace extends StatefulWidget {
  static const RouteName = './AddPlace';

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Place _tmpSave = Place(
    id: '',
    image: null,
    location: null,
    title: '',
  );

  void _getImage(File image) {
    _tmpSave = Place(
      id: _tmpSave.id,
      image: image,
      location: _tmpSave.location,
      title: _tmpSave.title,
    );
  }

  Future<void> _getPlace(double lat, double lng) async {
    final add = await LocationDB.getAddress(lat, lng);
    final newLoc = Location(latitude: lat, longitude: lng, address: add);
    _tmpSave = Place(
      id: _tmpSave.id,
      image: _tmpSave.image,
      title: _tmpSave.title,
      location: newLoc,
    );
  }

  Future<void> _saveForm() async {
    bool check = _formkey.currentState.validate();
    print(_tmpSave.location);
    if (!check || _tmpSave.location == null) {
      return;
    }

    _formkey.currentState.save();
    final p = Provider.of<Places>(context, listen: false);
    await p.addData(_tmpSave);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add a New Place')),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        label: Text('Title'),
                      ),
                      onSaved: (newValue) {
                        _tmpSave = Place(
                          id: _tmpSave.id,
                          image: _tmpSave.image,
                          location: _tmpSave.location,
                          title: newValue,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty || value == null) {
                          return 'Please enter something';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    AddImage(_getImage),
                    GetPlace(_getPlace),
                  ],
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _saveForm(),
              icon: Icon(Icons.add),
              label: Text('Add Place'),
              style: ElevatedButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: Theme.of(context).accentColor,
                foregroundColor: Colors.black,
              ),
            )
          ]),
    );
  }
}
