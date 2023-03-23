import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../provider/product_provider.dart';

class Product_Detail extends StatelessWidget {
  static const RouteName = './product_detail';
  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments;
    final p = Provider.of<Product_Provider>(
      context,
      listen: false,
    ).itemById(id);

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(p.title),
            background: Hero(
              tag: p.id,
              child: Image.network(
                p.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '\$${p.price}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  p.description,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 800),
            ],
          ),
        ),
      ],
    ));
  }
}
