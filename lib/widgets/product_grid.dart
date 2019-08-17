import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';
import './product_item.dart';

class ProductGrid extends StatelessWidget {
  final showFavs;
  ProductGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    List<Product> products = showFavs?Provider.of<Products>(context).favoriteItems:Provider.of<Products>(context).items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemBuilder: (ctx, i) => ChangeNotifierProvider<Product>.value(
          value:products[i], child: ProductItem()),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
      ),
    );
  }
}
