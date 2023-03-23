import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/add_product.dart';
import '../provider/product_provider.dart';

class User_Item extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;

  User_Item({
    this.id,
    this.imageUrl,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(Add_Product.RouteName, arguments: id);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () async {
              try {
                await Provider.of<Product_Provider>(context, listen: false)
                    .deleteProduct(id);
              } catch (error) {
                scaffold.hideCurrentSnackBar();
                scaffold
                    .showSnackBar(SnackBar(content: Text('Failed to delete')));
              }
            },
          )
        ],
      ),
    );
  }
}
