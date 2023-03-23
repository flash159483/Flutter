import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';

class Cart_Item extends StatelessWidget {
  final String itemId;
  final String id;
  final String title;
  final double price;
  final int quantity;

  Cart_Item({this.id, this.title, this.price, this.quantity, this.itemId});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you really want to remove this item from Cart?'),
            actions: [
              TextButton(
                child: Text('Yes'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
              TextButton(
                child: Text('No'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        );
      },
      key: ValueKey(itemId),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).deleteItem(itemId);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white, size: 40),
      ),
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text('\$${price.toStringAsFixed(2)}'),
                ),
                fit: BoxFit.cover,
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('${quantity} x'),
          ),
        ),
      ),
    );
  }
}
