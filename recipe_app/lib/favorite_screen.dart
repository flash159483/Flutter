import 'package:flutter/material.dart';
import 'package:recipe_app/models/meal.dart';

import './Meal_list.dart';

class Favorite_Screen extends StatelessWidget {
  final List<Meal> favorite;
  Favorite_Screen(this.favorite);
  @override
  Widget build(BuildContext context) {
    return favorite.isEmpty
        ? Center(
            child: Text('No favorite added yet! try add some',
                style: Theme.of(context).textTheme.headline6),
          )
        : ListView.builder(
            itemBuilder: ((context, index) {
              return Meal_List(
                id: favorite[index].id,
                image_url: favorite[index].imageUrl,
                title: favorite[index].title,
                complexity: favorite[index].complexity,
                duration: favorite[index].duration,
                afford: favorite[index].affordability,
              );
            }),
            itemCount: favorite.length,
          );
  }
}
