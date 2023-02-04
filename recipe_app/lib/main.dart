import 'package:flutter/material.dart';
import 'package:recipe_app/Setting_screen.dart';

import './models/meal.dart';
import './tabs_screen.dart';
import './Meal_Detail.dart';
import './Meal_list.dart';
import './Category_Meal_screen.dart';
import './Category_screen.dart';
import './dummy_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filtered = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };

  List<Meal> _availableMeal = DUMMY_MEALS;
  List<Meal> _favoriteMeal = [];

  void _setFilter(g, l, v, ve) {
    setState(() {
      _filtered['gluten'] = g;
      _filtered['lactose'] = l;
      _filtered['vegan'] = v;
      _filtered['vegetarian'] = ve;

      _availableMeal = DUMMY_MEALS.where(
        (element) {
          if (_filtered['gluten'] && !element.isGlutenFree) {
            return false;
          }
          if (_filtered['lactose'] && !element.isLactoseFree) {
            return false;
          }
          if (_filtered['vegan'] && !element.isVegan) {
            return false;
          }
          if (_filtered['vegetarian'] && !element.isVegetarian) {
            return false;
          }
          return true;
        },
      ).toList();
    });
  }

  void _toggleFavorite(String id) {
    final exist = _favoriteMeal.indexWhere((element) => element.id == id);

    if (exist >= 0) {
      setState(() {
        _favoriteMeal.removeAt(exist);
      });
    } else {
      setState(() {
        _favoriteMeal
            .add(DUMMY_MEALS.firstWhere((element) => element.id == id));
      });
    }
  }

  bool _existMeal(String id) {
    return _favoriteMeal.any(
      (element) => element.id == id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            bodyText1: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            bodyText2: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            headline6: TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold)),
      ),
      routes: {
        '/': (context) => Tabs_Screen(_favoriteMeal),
        Screen.Route_Name: (context) => Category_screen(_availableMeal),
        Meal_List.routeName: (context) =>
            Meal_Detail(_toggleFavorite, _existMeal),
        Setting_Screen.RouteName: ((context) =>
            Setting_Screen(_setFilter, _filtered)),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
            builder: ((context) => Category_screen(_availableMeal)));
      },
    );
  }
}
