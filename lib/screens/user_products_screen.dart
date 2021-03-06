import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import '../widgets/drawer.dart';
import '../screens/edit_product.dart';
class UserProductsScreen extends StatelessWidget {
  static const namedroute = '/user-products';
  Future<void> _refreshProducts(BuildContext context) async{
    try{
    await Provider.of<Products>(context).getProducts();
    }catch(error){
      print(error);
    }
  }
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProduct.namedroute);
            },
          )
        ],
      ),
      drawer: DrawerWidget(),
      body: RefreshIndicator(
        onRefresh: ()=>_refreshProducts(context),
              child: ListView.builder(
          itemBuilder: (ctx, i) {
            return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    children: [
                      UserProductItem(productData.items[i]), 
                      Divider()
                      ]
                      ),
            );
          },
          itemCount: productData.items.length,
        ),
      ),
    );
  }
}
