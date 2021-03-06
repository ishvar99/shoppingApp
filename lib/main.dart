import 'package:flutter/material.dart';
import 'package:shop_app2/screens/auth_screen.dart';
import './screens/edit_product.dart';
import './screens/user_products_screen.dart';
import './providers/orders.dart';
import './screens/product_details.dart';
import './screens/products_overview.dart';
import 'package:provider/provider.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/cart.dart';
import './screens/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Products>.value(value: Products()),
        ChangeNotifierProvider<Cart>.value(
          value: Cart(),
        ),
        ChangeNotifierProvider<Orders>.value(
          value: Orders(),
        )
      ],
      //  builder: (_)=>Products(),// use value constructor if you don't need ctx argument in builder
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        home:AuthScreen(),
        routes: {
          ProductDetailsScreen.namedRoute: (_) => ProductDetailsScreen(),
          CartScreen.namedroute: (_) => CartScreen(),
          OrdersScreen.namedroute:(_)=>OrdersScreen(),
          UserProductsScreen.namedroute:(_)=>UserProductsScreen(),
          EditProduct.namedroute:(_)=>EditProduct()
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}
