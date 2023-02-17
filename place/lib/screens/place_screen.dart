import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './add_place.dart';
import '../provider/places.dart';
import './place_detail.dart';

class PlaceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlace.RouteName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Places>(context, listen: false).getData(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<Places>(
                child: Center(
                    child: const Text(
                        'No places added yet please add your own Places!')),
                builder: (context, value, ch) {
                  return value.items.length <= 0
                      ? ch
                      : ListView.builder(
                          itemCount: value.items.length,
                          itemBuilder: (context, i) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage: FileImage(value.items[i].image),
                            ),
                            title: Text(value.items[i].title),
                            subtitle: Text(value.items[i].location.address),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  PlaceDetailScreen.routeName,
                                  arguments: value.items[i].id);
                            },
                          ),
                        );
                },
              ),
      ),
    );
  }
}
