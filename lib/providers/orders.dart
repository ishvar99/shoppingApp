import 'package:flutter/foundation.dart';
import '../providers/cart.dart';

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
  void addOrder(List<CartItem> cartItems,double total) {
    _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            orders: cartItems,
            totalAmount: total,
            date: DateTime.now()));
    notifyListeners();
  }
}
