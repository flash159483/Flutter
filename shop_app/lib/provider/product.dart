import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/httpexception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool favorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.favorite = false,
  });

  Future<void> toggleFavorite(String id, String userId, String token) async {
    favorite = !favorite;
    notifyListeners();
    final url = Uri.parse(
        'https://testproject-eae32-default-rtdb.firebaseio.com/userFavorite/$userId/$id.json?auth=$token');

    final response = await http.put(url, body: json.encode(favorite));

    if (response.statusCode >= 400) {
      favorite = !favorite;
      notifyListeners();
      throw HttpException('Update failed');
    }
  }
}
