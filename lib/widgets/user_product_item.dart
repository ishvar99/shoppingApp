import 'package:flutter/material.dart';
import '../screens/edit_product.dart';
import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final Product product;
  UserProductItem(this.product);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
        title: Text(product.title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
        ),
        trailing: Container(
          width: 100,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.pushNamed(context, EditProduct.namedroute,
                    arguments: product.id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Are you Sure'),
                    content:
                        Text('Do you want to delete this product permanently!'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                      FlatButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      )
                    ],
                  ),
                ).then((val) async {
                  if (val)
                    try {
                      await Provider.of<Products>(context, listen: false)
                          .deleteProduct(product.id);
                    } catch (_) {
                      scaffold.showSnackBar(SnackBar(
                          content: Text(
                        'Deletion Error',
                        textAlign: TextAlign.center,
                      )));
                    }
                });
              },
            )
          ]),
        ));
  }
}
