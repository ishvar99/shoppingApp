import 'dart:io';

import 'package:flutter/foundation.dart';
import '../providers/cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final List<CartItem> orders;
  final double totalAmount;
  final DateTime date;
  OrderItem(
      {@required this.id, @required this.orders, this.date, this.totalAmount});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = 'http://192.168.56.1:3000/api/orders';
    var res = await http.get(url);
    List<OrderItem> _loadedOrders=[];
    var response=json.decode(res.body);
    if(response==null){
      return;
    }
    response.forEach((m) {
      List<CartItem> _items = [];
      m['products'].forEach((p) {
        _items.insert(
          0,
          CartItem(
            id: p['_id'],
            title: p['title'],
            price: p['price'].toDouble(),
            quantity: p['quantity'],
          ),
        );
      });
      _loadedOrders.insert(
          0,
          OrderItem(
            id: m['_id'],
            orders: _items,
            totalAmount: m['amount'],
            date: DateTime.parse(m['date']),
          ));
    });
    _orders=_loadedOrders; //Because _loadedOrders=[] at the start of function
    notifyListeners();
    // _orders=json.decode(res.body) as List<OrderItem>;
  }

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    final url = 'http://192.168.56.1:3000/api/orders';
    var timestamp = DateTime.now();
    try {
      var body = json.encode({
        'amount': total,
        'date': timestamp.toIso8601String(),
        'products': cartItems
            .map((cp) => {
                  // 'id':cp.id,
                  'title': cp.title,
                  'price': cp.price,
                  'quantity': cp.quantity
                })
            .toList()
      });
      print(body);
      final response = await http.post(url, body: body, headers: {
        'Content-type': 'application/json',
        'accept': 'application/json'
      });
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }
}
