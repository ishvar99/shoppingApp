import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });
  void _setFavValue(val){
    isFavorite=val;
    notifyListeners();
  }
  Future<void> toggleFavoriteStatus() async {
    final url = 'https://flutter-shopapp-6d9e6.firebaseio.com/products/$id.json';
    bool oldValue=isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response =
          await http.patch(url, body: json.encode({'isFavorite': isFavorite}));
          if(response.statusCode>=400){
            _setFavValue(oldValue);
          }
    } catch (error) {
      _setFavValue(oldValue);
  }
}
}
