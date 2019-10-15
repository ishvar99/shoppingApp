import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/HttpException.dart';
class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  List<Product> get items {
    return [..._items]; //We send a copy of items
  }

  Product findById(id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> getProducts() async {
    // const url = 'https://flutter-shopapp-6d9e6.firebaseio.com/products.json';
    const url='http://192.168.56.1:3000/api/shop';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      if (extractedData == null) return;
      final List<Product> loadedProducts = [];
      extractedData.forEach((val){
           loadedProducts.add(
          Product(
              id: val['_id'],
              title: val['title'],
              description: val['description'],
              imageUrl: val['imageUrl'],
              price: val['price'],
              isFavorite:val['isFavorite'])
        );
      });
      // extractedData.forEach((prodKey, prodData) {
      //   loadedProducts.add(
      //     Product(
      //         id: prodKey,
      //         title: prodData['title'],
      //         description: prodData['description'],
      //         imageUrl: prodData['imageUrl'],
      //         price: prodData['price'],
      //         isFavorite:prodData['isFavorite'])
      //   );
        _items = loadedProducts;
      // });
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    // const url = 'https://flutter-shopapp-6d9e6.firebaseio.com/products.json';
    const url='http://192.168.56.1:3000/api/shop';
    try {
      final response = await http.post(url,
      headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    },
             body: {
            'title': product.title,
            'price':product.price.toString(),
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite.toString()
          },
          encoding: Encoding.getByName("utf-8"));
       print(response.body);
      _items.add(Product(
        id: json.decode(response.body)['_id'],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      ));
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future<void> updateProduct(String productId, Product newProduct) async {
    final url =
        'https://flutter-shopapp-6d9e6.firebaseio.com/products/$productId.json';
    int prodIndex = _items.indexWhere((pro) => pro.id == productId);
    await http.patch(url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl
        }));
    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-shopapp-6d9e6.firebaseio.com/products/$id.json';
    int productIndex = _items.indexWhere((pro) => pro.id == id);
    Product removedProduct = _items[productIndex];
    _items.removeAt(productIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(productIndex,removedProduct);
       notifyListeners();
      throw HttpException('Deletion Failed!');
    }
   removedProduct=null;
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }
  // showAll(){
  //   _showFavoritesOnly=false;
  //   notifyListeners();
  // }
  //  showFavorites(){
  //    _showFavoritesOnly=true;
  //    notifyListeners();
  //  }
}
