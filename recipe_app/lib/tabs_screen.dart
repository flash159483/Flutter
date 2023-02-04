import 'package:flutter/material.dart';
import 'package:recipe_app/models/meal.dart';

import './main_drawer.dart';
import './favorite_screen.dart';
import './Category_screen.dart';

class Tabs_Screen extends StatefulWidget {
  List<Meal> favoriteList;

  Tabs_Screen(this.favoriteList);
  @override
  State<Tabs_Screen> createState() => _Tabs_ScreenState();
}

class _Tabs_ScreenState extends State<Tabs_Screen> {
  int _selected = 0;

  List<Map<String, Object>> _screens;

  @override
  void initState() {
    _screens = [
      {
        'page': Screen(),
        'title': 'Categories',
      },
      {
        'page': Favorite_Screen(widget.favoriteList),
        'title': 'Favorites',
      }
    ];
    super.initState();
  }

  void _selectScreen(index) {
    setState(() {
      _selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_selected]['title']),
      ),
      body: _screens[_selected]['page'],
      drawer: Main_Drawer(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectScreen,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.white,
        currentIndex: _selected,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorite',
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
