import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;
  CartItem({this.id, this.quantity, this.price, this.title});
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      onDismissed: (dimissdirection) {
        cart.removeItem(id);
      },
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  content:
                      Text('Do you want to remove this product from cart?'),
                  title: Text('Are you sure?'),
                  actions: <Widget>[
                    FlatButton(child: Text('NO'),onPressed: (){
                       Navigator.of(context).pop(false);
                    },),
                  FlatButton(child: Text('YES'),onPressed: (){
                       Navigator.of(context).pop(true);
                    },)
                  ],
                ));
      },
      background: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                    child: Text('\$${price.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ),
            ),
            title: Text(title),
            subtitle: Text(
              'Total: \$${(price * quantity).toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text('$quantity X'),
          ),
        ),
      ),
    );
  }
}
