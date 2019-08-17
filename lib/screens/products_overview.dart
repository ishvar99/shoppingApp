import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import './cart.dart';
enum filterOptions { showFavorites, showAll }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavorites = false;
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('ShopApp'),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.namedroute);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
          PopupMenuButton(
            onSelected: (filterOptions val) {
              setState(() {
                if (val == filterOptions.showFavorites)
                  _showFavorites = true;
                else
                  _showFavorites = false;
              });
            },
            itemBuilder: (_) => [
              //We return list of widgets
              //which are added as entries in popup menu
              PopupMenuItem(
                value: filterOptions.showFavorites,
                child: Text('Show Favorites'),
              ),
              PopupMenuItem(
                value: filterOptions.showAll,
                child: Text('Show All'),
              )
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: new ProductGrid(_showFavorites),
      drawer: DrawerWidget()
    );
  }
}
