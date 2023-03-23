import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../provider/product_provider.dart';
import '../widgets/user_item.dart';
import './add_product.dart';

class User_Product extends StatelessWidget {
  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Product_Provider>(context, listen: false)
        .fetchProduct(true);
  }

  static const RouteName = './User_Product';
  @override
  Widget build(BuildContext context) {
    //final productList = Provider.of<Product_Provider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Product'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Add_Product.RouteName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: App_Drawer(),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return Container();
            } else {
              return RefreshIndicator(
                onRefresh: () => _refresh(context),
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Consumer<Product_Provider>(
                      builder: (context, productList, child) =>
                          ListView.builder(
                        itemCount: productList.item.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              User_Item(
                                id: productList.item[index].id,
                                imageUrl: productList.item[index].imageUrl,
                                title: productList.item[index].title,
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    )),
              );
            }
          }
        },
      ),
    );
  }
}
