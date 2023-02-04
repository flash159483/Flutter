import 'package:flutter/material.dart';

import './Category_box.dart';
import './dummy_data.dart';

class Screen extends StatelessWidget {
  static const Route_Name = './Category-screen';
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(15),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1.5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemBuilder: ((context, index) {
        return Category_Box(DUMMY_CATEGORIES[index].color,
            DUMMY_CATEGORIES[index].title, DUMMY_CATEGORIES[index].id);
      }),
      itemCount: DUMMY_CATEGORIES.length,
    );
  }
}
