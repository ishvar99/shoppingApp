import 'package:flutter/material.dart';
import '../screens/orders.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          // Container(
          //   height: 90,
          //   width: double.infinity,
          //   child: Padding(
          //     padding: const EdgeInsets.only(top: 40, left: 15),
          //     child: Text(
          //       'Hello Friend!',
          //       style: TextStyle(color: Colors.white, fontSize: 22),
          //     ),
          //   ),
          //   color: Theme.of(context).primaryColor,
          // ),
          Divider(),
          ListTile(
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
            leading: Icon(Icons.shop),
            title: Text(
              'Shop',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.namedroute),
            leading: Icon(Icons.payment),
            title: Text('Orders', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
