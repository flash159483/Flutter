import 'package:expense_app_real/include/transaction_format.dart';
import 'package:expense_app_real/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  List<TransactionFormat> recent;

  List<Map<String, Object>> get getValuePerTime {
    return List.generate(7, (index) {
      var weekdays = DateTime.now().subtract(Duration(days: index));
      int total = 0;

      for (var i = 0; i < recent.length; i++) {
        if (recent[i].date.day == weekdays.day &&
            recent[i].date.month == weekdays.month &&
            recent[i].date.year == weekdays.year) {
          total += recent[i].price;
        }
      }
      return {
        'days': DateFormat.E().format(weekdays).substring(0, 3),
        'total': total,
      };
    }).reversed.toList();
  }

  int get totalSpending {
    return getValuePerTime.fold(0, (sum, item) {
      return sum + item['total'];
    });
  }

  Chart(this.recent);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Column(
          children: [
            Text('Last 7 days expenses made',
                style: Theme.of(context).textTheme.subtitle1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: getValuePerTime.map((e) {
                return Flexible(
                  child: ChartBar(
                      e['total'],
                      e['days'],
                      totalSpending == 0.0
                          ? 0.0
                          : (e['total'] as int) / totalSpending),
                  fit: FlexFit.tight,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
