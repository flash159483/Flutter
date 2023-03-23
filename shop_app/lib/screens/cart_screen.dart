import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/order.dart';

import '../widgets/cart_item.dart';
import '../provider/cart.dart';
import '../provider/auth.dart';

class Cart_Screen extends StatelessWidget {
  static const RouteName = '/Cart_screen';
  @override
  Widget build(BuildContext context) {
    final cart_items = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total'),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart_items.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Order_Button(cart_items: cart_items),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart_items.cartLen,
              itemBuilder: (context, index) {
                var cur = cart_items.cart.values.toList()[index];
                return Cart_Item(
                  id: cur.id,
                  price: cur.price,
                  quantity: cur.quantity,
                  title: cur.title,
                  itemId: cart_items.cart.keys.toList()[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Order_Button extends StatefulWidget {
  const Order_Button({
    Key key,
    @required this.cart_items,
  }) : super(key: key);

  final Cart cart_items;

  @override
  State<Order_Button> createState() => _Order_ButtonState();
}

class _Order_ButtonState extends State<Order_Button> {
  var _loading = false;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return TextButton(
      onPressed: widget.cart_items.cartLen == 0 || _loading
          ? null
          : () async {
              try {
                setState(() {
                  _loading = true;
                });
                await Provider.of<Order>(context, listen: false).addOrder(
                  widget.cart_items.cart.values.toList(),
                  widget.cart_items.totalPrice,
                  auth.userId,
                );
                widget.cart_items.clearCart();
              } catch (error) {
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Failed to add Order'),
                    content: Text('Please try again later'),
                    actions: [
                      TextButton(
                        child: Text('Ok'),
                        onPressed: () => Navigator.of(ctx).pop(),
                      )
                    ],
                  ),
                );
              }
              setState(() {
                _loading = false;
              });
            },
      child: _loading
          ? CircularProgressIndicator()
          : Text(
              'Order Now',
            ),
    );
  }
}
