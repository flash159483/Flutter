import 'package:flutter/material.dart';
import './models/meal.dart';

class Meal_List extends StatelessWidget {
  final id;
  final String image_url;
  final String title;
  final int duration;
  final complexity;
  final afford;

  static const routeName = '/Meal-Detail';

  Meal_List({
    @required this.id,
    @required this.image_url,
    @required this.title,
    @required this.duration,
    @required this.complexity,
    @required this.afford,
  });

  String get Convert_afford {
    switch (afford) {
      case Affordability.Pricey:
        return 'Pricey';
      case Affordability.Luxurious:
        return 'Luxurious';
      case Affordability.Affordable:
        return 'Affordable';

      default:
        return 'Unknown';
    }
  }

  String get Convert_complexity {
    switch (complexity) {
      case Complexity.Simple:
        return 'Simple';
      case Complexity.Hard:
        return 'Hard';
      case Complexity.Challenging:
        return 'Challenging';

      default:
        return 'Unknown';
    }
  }

  void EnterDetail(BuildContext context) {
    Navigator.of(context).pushNamed(
      routeName,
      arguments: id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => EnterDetail(context),
      child: Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(image_url,
                      height: 250, width: double.infinity, fit: BoxFit.fill),
                ),
                Positioned(
                  bottom: 10,
                  right: 20,
                  child: Container(
                    width: 300,
                    color: Colors.black54,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 26, color: Colors.white),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule),
                      const SizedBox(width: 6),
                      Text('${duration} min'),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.work),
                      const SizedBox(width: 6),
                      Text(Convert_complexity),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.attach_money_rounded),
                      const SizedBox(width: 6),
                      Text(Convert_afford),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
