import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';
import './product_item.dart';

class Product_Grid extends StatelessWidget {
  var fav;
  Product_Grid(this.fav);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Product_Provider>(context);
    final product = fav ? productData.fav : productData.item;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.5,
        crossAxisCount: 2,
      ),
      itemCount: product.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: product[index],
        child: Product_Item(),
      ),
    );
  }
}
