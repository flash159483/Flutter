import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shop_app/provider/order.dart';

class Order_item extends StatefulWidget {
  final OrderItem order;

  Order_item(this.order);

  @override
  State<Order_item> createState() => _Order_itemState();
}

class _Order_itemState extends State<Order_item>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    super.initState();
  }

  void _iconhandler() {
    setState(() {
      _expanded = !_expanded;
      _expanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height: _expanded
          ? min(widget.order.products.length * 10.0 + 200, 180.0)
          : 105,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.price.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(widget.order.date),
              ),
              trailing: IconButton(
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_arrow,
                  progress: _controller,
                ),
                onPressed: () => _iconhandler(),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _expanded
                  ? min(widget.order.products.length * 10.0 + 85, 60.0)
                  : 0,
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: widget.order.products.length,
                itemBuilder: (context, index) {
                  var p = widget.order.products[index];
                  return Row(
                    children: [
                      Text(
                        p.title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('${p.quantity}x \$${p.price}'),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
