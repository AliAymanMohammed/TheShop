import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/product_provider.dart';
import '../Screens/edit_products.dart';
import '../Screens/user_product_item.dart';
import '../components.dart';

class UserProductScreen extends StatelessWidget {
  static const String routeName = '/User-Products';
  Future<void> refreshProducts(BuildContext context) async{
    return  await Provider.of<ProductProvider>(context , listen: false).getProducts(filterBy: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductsScreen.routeName);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
        future: refreshProducts(context),
        builder: (context , snapData) => snapData.connectionState == ConnectionState.waiting ? const Center(child: CircularProgressIndicator(),) : RefreshIndicator(
          child: Consumer<ProductProvider>(
            builder: (context , productsProvider , _) => ListView.builder(
              itemBuilder: (context, index) => UserProductItemScreen(
                title: productsProvider.Products[index].title,
                imageUrl: productsProvider.Products[index].imageUrl,
                id: productsProvider.Products[index].id,
              ),
              itemCount: productsProvider.Products.length,
            ),
          ),
          onRefresh: ()=> refreshProducts(context),
        ),
      ),
      drawer:
          buildDrawer(dTitle: 'Sections', backButton: false, context: context),
    );
  }
}
