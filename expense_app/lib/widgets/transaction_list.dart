import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../include/transaction_format.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionFormat> transactions;
  final Function removeData;

  TransactionList(this.transactions, this.removeData);

  @override
  Widget build(BuildContext context) {
    print(transactions.length);
    return Container(
      height: 400,
      child: transactions.isEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Text('No Transaction made so far',
                      style: Theme.of(context).textTheme.subtitle1),
                  Container(
                      margin: EdgeInsets.only(top: 20),
                      height: 300,
                      child: Image.asset(
                        'assets/images/sleep.jpg',
                        fit: BoxFit.fill,
                      ))
                ],
              ),
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: EdgeInsets.all(6),
                  child: Card(
                    elevation: 6,
                    margin: EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: FittedBox(
                            child: Text(NumberFormat('###,000')
                                .format(transactions[index].price)),
                          ),
                        ),
                      ),
                      title: Text(transactions[index].item),
                      subtitle: Text(
                          DateFormat.yMMMMd().format(transactions[index].date)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeData(index),
                      ),
                    ),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}
