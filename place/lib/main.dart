import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/places.dart';
import 'screens/place_screen.dart';
import 'screens/add_place.dart';
import 'screens/place_detail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Places(),
      child: MaterialApp(
        title: 'Great Places',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber,
        ),
        home: PlaceScreen(),
        routes: {
          AddPlace.RouteName: (context) => AddPlace(),
          PlaceDetailScreen.routeName: (context) => PlaceDetailScreen(),
        },
      ),
    );
  }
}
