import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';
import '../provider/product_provider.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import '../provider/cart.dart';

enum filteredFavorite {
  only,
  all,
}

class Product_Page extends StatefulWidget {
  @override
  State<Product_Page> createState() => _Product_PageState();
}

class _Product_PageState extends State<Product_Page> {
  bool _loading = false;
  bool _initialize = true;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_initialize) {
      setState(() {
        _loading = true;
      });
      Provider.of<Product_Provider>(context).fetchProduct().then((_) {
        ;
        setState(() {
          _loading = false;
        });
      });
    }
    _initialize = false;
    super.didChangeDependencies();
  }

  bool favsetting = false;
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product_Provider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (filteredFavorite value) {
                setState(() {
                  if (value == filteredFavorite.only) {
                    favsetting = true;
                  } else {
                    favsetting = false;
                  }
                });
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('show only favorite'),
                      value: filteredFavorite.only,
                    ),
                    PopupMenuItem(
                      child: Text('show all'),
                      value: filteredFavorite.all,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) {
              return Badges(value: cart.cartLen.toString(), child: ch);
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(Cart_Screen.RouteName);
              },
            ),
          ),
        ],
      ),
      drawer: App_Drawer(),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Product_Grid(favsetting),
    );
  }
}
