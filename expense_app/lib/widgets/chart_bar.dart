import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final int totalspending;
  final String item;
  final double percentage;

  ChartBar(this.totalspending, this.item, this.percentage);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraint) {
      return Column(
        children: [
          Container(
            height: 20,
            child: FittedBox(
              child: Text('\$${totalspending.toStringAsFixed(0)}'),
            ),
          ),
          SizedBox(height: 4),
          Container(
            height: 60,
            width: 10,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: percentage,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(item),
        ],
      );
    });
  }
}
