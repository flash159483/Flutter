import 'package:flutter/material.dart';

import './Category_screen.dart';

class Category_Box extends StatelessWidget {
  final Color color;
  final String title;
  final String id;

  Category_Box(this.color, this.title, this.id);

  void SwitchPage(BuildContext context) {
    Navigator.of(context).pushNamed(Screen.Route_Name, arguments: {
      'title': title,
      'id': id,
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => SwitchPage(context),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        child: Center(
          child: Text(title, style: Theme.of(context).textTheme.headline6),
        ),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
