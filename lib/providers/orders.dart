import 'package:flutter/foundation.dart';
import '../providers/cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
    final url='';
    var timestamp=DateTime.now();
    final response=await http.post(url,body: json.encode({
      'amount':total,
      'date':timestamp.toIso8601String(),
      'products':
        cartItems.map((cp)=>{
          'id':cp.id,
          'title':cp.title,
          'price':cp.price,
          'quantity':cp.quantity
        }).toList()
    }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            orders: cartItems,
            totalAmount: total,
            date: timestamp));
    notifyListeners();
  }
}
