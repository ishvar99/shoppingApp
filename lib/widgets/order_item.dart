import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('${widget.order.totalAmount.toStringAsFixed(2)}'),
            subtitle:
                Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date)),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
              height: min(widget.order.orders.length * 20.0 + 10, 100),
              child: ListView(
                  children: widget.order.orders.map((item) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        item.title,
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${item.quantity}X \$${item.price}',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      )
                    ]);
              }).toList()),
            )
        ],
      ),
    );
  }
}
