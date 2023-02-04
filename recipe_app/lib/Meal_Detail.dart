import 'package:flutter/material.dart';

import './dummy_data.dart';

class Meal_Detail extends StatelessWidget {
  final Function favorite;
  final Function ifexist;

  Meal_Detail(this.favorite, this.ifexist);

  Widget buildText(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(text, style: Theme.of(context).textTheme.headline6),
    );
  }

  Widget buildContainer(Widget child) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.grey),
        ),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        height: 150,
        width: 300,
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;

    final filtered = DUMMY_MEALS.firstWhere((element) {
      return element.id == id;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(filtered.title),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: ifexist(id) ? Icon(Icons.star) : Icon(Icons.star_border),
        onPressed: () => favorite(id),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(filtered.imageUrl, fit: BoxFit.cover),
          ),
          buildText(context, 'Ingredient'),
          buildContainer(
            ListView.builder(
              itemBuilder: ((context, index) {
                return Card(
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(filtered.ingredients[index])),
                );
              }),
              itemCount: filtered.ingredients.length,
            ),
          ),
          buildText(context, 'Steps'),
          buildContainer(
            ListView.builder(
              itemCount: filtered.steps.length,
              itemBuilder: ((context, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Text('# ${index + 1}'),
                      ),
                      title: Text(filtered.steps[index]),
                    ),
                    Divider(),
                  ],
                );
              }),
            ),
          ),
        ]),
      ),
    );
  }
}
