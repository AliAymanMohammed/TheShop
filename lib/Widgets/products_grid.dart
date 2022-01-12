import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/Widgets/product_item.dart';
import '../Providers/product_provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool isFavoriteSelected;
  ProductsGrid(this.isFavoriteSelected);
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = isFavoriteSelected ? productProvider.favoritesProducts : productProvider.Products;
    return productProvider.Products.length > 0 ?GridView.builder(
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(),
      ),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(10),
    ) : Center(child: CircularProgressIndicator(),);
  }
}
