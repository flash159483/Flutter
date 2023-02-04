import 'package:flutter/material.dart';
import 'package:recipe_app/Setting_screen.dart';

class Main_Drawer extends StatelessWidget {
  Widget buildList(IconData icons, String title, Function tapHandler) {
    return ListTile(
      leading: Icon(icons, size: 26),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            padding: EdgeInsets.all(20),
            color: Theme.of(context).accentColor,
            alignment: Alignment.centerLeft,
            child: Text(
              'Cooking Up!',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontFamily: 'RobotoCondensed',
                  color: Theme.of(context).primaryColor,
                  fontSize: 36),
            ),
          ),
          SizedBox(height: 10),
          buildList(
            Icons.restaurant,
            'Meals',
            () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          buildList(
            Icons.settings,
            'Setting',
            () {
              Navigator.of(context)
                  .pushReplacementNamed(Setting_Screen.RouteName);
            },
          ),
        ],
      ),
    );
  }
}
