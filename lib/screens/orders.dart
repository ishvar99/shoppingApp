import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
class OrdersScreen extends StatelessWidget {
  static const namedroute='/orders';
  @override
  Widget build(BuildContext context) {
    final orders=Provider.of<Orders>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(itemCount: orders.length,itemBuilder: (ctx,i)=>OrderItem(orders[i])),
      drawer: DrawerWidget(),
    );
  }
}
