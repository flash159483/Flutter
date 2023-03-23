import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/httpexception.dart';

class Product_Provider with ChangeNotifier {
  List<Product> _item = [];

  final _token;
  final _userId;

  Product_Provider(this._token, this._item, this._userId);

  List<Product> get item {
    return [..._item];
  }

  List<Product> get fav {
    return _item.where((element) => element.favorite == true).toList();
  }

  Product itemById(String id) {
    return _item.firstWhere((element) => element.id == id);
  }

  Future<void> fetchProduct([filterByUser = false]) async {
    final check = filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    final url = Uri.parse(
        'https://testproject-eae32-default-rtdb.firebaseio.com/products.json?auth=$_token&$check');
    try {
      var response = await http.get(url);
      final datas = json.decode(response.body) as Map<String, dynamic>;
      final fav = Uri.parse(
          'https://testproject-eae32-default-rtdb.firebaseio.com/userFavorite/$_userId.json?auth=$_token');
      response = await http.get(fav);
      final favorite = json.decode(response.body);
      if (datas == null) {
        return;
      }
      final List<Product> tmp = [];
      datas.forEach((key, value) {
        tmp.add(Product(
            id: key,
            description: value['description'],
            imageUrl: value['imageUrl'],
            price: value['price'],
            title: value['title'],
            favorite: favorite == null ? false : favorite[key] ?? false));
      });
      _item = tmp;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product p) async {
    final url = Uri.parse(
        'https://testproject-eae32-default-rtdb.firebaseio.com/products.json?auth=$_token');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': p.title,
          'description': p.description,
          'imageUrl': p.imageUrl,
          'price': p.price,
          'creatorId': _userId,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        description: p.description,
        imageUrl: p.imageUrl,
        price: p.price,
        title: p.title,
      );
      _item.add(newProduct);
    } catch (error) {
      print(error);
      throw error;
    }

    notifyListeners();
  }

  Future<void> updateProduct(String id, Product p) async {
    final index = _item.indexWhere((element) => element.id == id);
    if (index >= 0) {
      final url = Uri.parse(
          'https://testproject-eae32-default-rtdb.firebaseio.com/products/$id.json?auth=$_token');
      http.patch(url,
          body: json.encode({
            'title': p.title,
            'description': p.description,
            'imageUrl': p.imageUrl,
            'price': p.price,
          }));
      _item[index] = p;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://testproject-eae32-default-rtdb.firebaseio.com/products/$id.json?auth=$_token');
    final oldId = _item.indexWhere((element) => element.id == id);
    var oldelement = _item[oldId];
    _item.removeAt(oldId);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _item.insert(oldId, oldelement);
      notifyListeners();
      throw HttpException('Failed to delete item');
    }
    oldelement = null;
  }
}
