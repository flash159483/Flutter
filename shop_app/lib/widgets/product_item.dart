import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../provider/product.dart';
import '../screens/product_detail.dart';
import '../provider/auth.dart';

class Product_Item extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    final sc = ScaffoldMessenger.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(Product_Detail.RouteName, arguments: product.id);
            },
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                  placeholder:
                      AssetImage('assets/images/product-placeholder.png'),
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover),
            )),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              product.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          leading: Consumer<Product>(
            builder: (ctx, value, child) {
              return IconButton(
                onPressed: () async {
                  try {
                    await product.toggleFavorite(
                        product.id, auth.userId, auth.token);
                  } catch (error) {
                    sc.hideCurrentSnackBar();
                    sc.showSnackBar(
                        SnackBar(content: Text('Failed to update Favorite')));
                  }
                },
                icon: Icon(
                  product.favorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
              );
            },
          ),
          trailing: IconButton(
            onPressed: () {
              cart.updateCart(product.id, product.title, product.price);
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item has been added to the Cart!'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () => cart.removeItem(product.id),
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
