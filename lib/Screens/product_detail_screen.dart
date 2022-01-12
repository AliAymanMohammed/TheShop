import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final pId = ModalRoute.of(context).settings.arguments as String;
    final productItemsProvider= Provider.of<ProductProvider>(context , listen: false).findById(pId);

    return Scaffold(
      appBar: AppBar(
        title: Text(productItemsProvider.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              margin: const EdgeInsets.all(8),
              child: Hero(
                tag: productItemsProvider.id,
                  child: Image.network(productItemsProvider.imageUrl , fit: BoxFit.cover,)),
            ),
            const SizedBox(height: 10,),
            Text('${productItemsProvider.price} EGP' , style:  TextStyle(fontSize: 20 ,color: Colors.brown.withOpacity(0.8)),),
            const SizedBox(height: 10,),
            SizedBox(
                child: Text(
                  productItemsProvider.description,
                  style: const TextStyle(fontSize: 20),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
