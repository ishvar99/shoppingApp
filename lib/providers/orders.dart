import 'dart:io';

import 'package:flutter/foundation.dart';
import '../providers/cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
class OrderItem {
  final String id;
  final List<CartItem> orders;
  final double totalAmount;
  final DateTime date;
  OrderItem({@required this.id, @required this.orders, this.date,this.totalAmount});
}
class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders{
    return [..._orders];
  }
  Future<void> addOrder(List<CartItem> cartItems,double total) async{
    final url='http://192.168.56.1:3000/api/orders';
    var timestamp=DateTime.now();
    try{
      var body=json.encode({
      'amount':total.toString(),
      'date':timestamp.toIso8601String(),
      'products':
        cartItems.map((cp)=>{
          // 'id':cp.id,
          'title':cp.title,
          'price':cp.price,
          'quantity':cp.quantity
        }).toList()
    });
    print(body);
    final response=await http.post(url,body:body,headers: {
    'Content-type': 'application/json',
    'accept': 'application/json'
    });
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['_id'],
            orders: cartItems,
            totalAmount: total,
            date: timestamp));
    notifyListeners();
    }catch(err){
      print(err);
    }
  }
}
