import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const namedRoute = '/product-details';

  @override
  Widget build(BuildContext context) {
    String productId = ModalRoute.of(context).settings.arguments as String;
    Product product =
        Provider.of<Products>(context, listen: false).findById(productId);
    //listen false means it will stop listening to further changes in Products list
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(children: [
        Container(
          height: 300,
          width: double.infinity,
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          '\$${product.price}',
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          child: Text(
            product.description,
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(fontSize: 18),
          ),
        )
      ]),
    );
  }
}
