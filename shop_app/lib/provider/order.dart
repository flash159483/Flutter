import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './cart.dart';

class OrderItem {
  final String id;
  final double price;
  final DateTime date;
  final List<CartItem> products;

  OrderItem({
    @required this.id,
    @required this.price,
    @required this.date,
    @required this.products,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orderList = [];
  final String _token;

  Order(this._token, this._orderList);

  List<OrderItem> get orderList {
    return [..._orderList];
  }

  Future<void> fetchOrder(String userId) async {
    final url = Uri.parse(
        'https://testproject-eae32-default-rtdb.firebaseio.com/orders/$userId.json?auth=$_token');
    try {
      final response = await http.get(url);
      final datas = json.decode(response.body) as Map<String, dynamic>;
      if (datas == null) {
        return;
      }
      final List<OrderItem> tmp = [];
      datas.forEach((key, value) {
        tmp.add(
          OrderItem(
            id: key,
            price: value['price'],
            date: DateTime.parse(value['date']),
            products: (value['product'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ),
                )
                .toList(),
          ),
        );
      });
      _orderList = tmp.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(
      List<CartItem> product, double price, String userId) async {
    final url = Uri.parse(
        'https://testproject-eae32-default-rtdb.firebaseio.com/orders/$userId.json?auth=$_token');

    final timestamp = DateTime.now();

    try {
      final response = await http.post(url,
          body: json.encode(
            {
              'date': timestamp.toIso8601String(),
              'price': price,
              'product': product
                  .map((e) => {
                        'id': e.id,
                        'title': e.title,
                        'price': e.price,
                        'quantity': e.quantity,
                      })
                  .toList(),
            },
          ));
      _orderList.insert(
        0,
        OrderItem(
          date: timestamp,
          id: json.decode(response.body)['name'],
          price: price,
          products: product,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
