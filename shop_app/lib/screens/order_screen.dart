import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/provider/order.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../provider/auth.dart';

class Order_Screen extends StatelessWidget {
  static const RouteName = './Order_Screen';
  Future<void> _updateList(BuildContext context, String userId) async {
    await Provider.of<Order>(context, listen: false).fetchOrder(userId);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Order Page'),
        ),
        drawer: App_Drawer(),
        body: FutureBuilder(
          future: _updateList(context, auth.userId),
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.error != null) {
                print(snapshot.error);
              } else {
                return RefreshIndicator(
                  onRefresh: () => _updateList(context, auth.userId),
                  child: Consumer<Order>(
                    builder: (context, order, child) => ListView.builder(
                      itemBuilder: (context, index) =>
                          Order_item(order.orderList[index]),
                      itemCount: order.orderList.length,
                    ),
                  ),
                );
              }
            }
          },
        ));
  }
}
