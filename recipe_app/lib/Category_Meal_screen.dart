import 'package:flutter/material.dart';

import 'package:recipe_app/Meal_list.dart';

class Category_screen extends StatelessWidget {
  final selectedMeal;
  Category_screen(this.selectedMeal);

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final title = routeArgs['title'];
    final id = routeArgs['id'];

    final filtedMeal = selectedMeal.where(
      (element) {
        return element.categories.contains(id) as bool;
      },
    ).toList();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemBuilder: ((context, index) {
          return Meal_List(
            id: filtedMeal[index].id,
            image_url: filtedMeal[index].imageUrl,
            title: filtedMeal[index].title,
            complexity: filtedMeal[index].complexity,
            duration: filtedMeal[index].duration,
            afford: filtedMeal[index].affordability,
          );
        }),
        itemCount: filtedMeal.length,
      ),
    );
  }
}
