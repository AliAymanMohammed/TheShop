import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../Providers/product_provider.dart';
import '../Providers/cart.dart';
import '../Widgets/badge.dart';
import '../Widgets/products_grid.dart';
import '../Screens/cart_screen.dart';
import '../components.dart';


class ProductsOverViewScreen extends StatefulWidget {
  static const String routeName = '/products-overView';
  @override
  State<ProductsOverViewScreen> createState() => _ProductsOverViewScreenState();
}
enum selectedProducts{
Favorites,
  All
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var isFavoriteSelected = false;

  @override
  void initState() {
    Provider.of<ProductProvider>(context ,listen: false).getProducts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Padding(
          padding:  EdgeInsets.only(left: 40),
          child: Text('Your Shop'),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (selectedProducts selected){
              if(selected == selectedProducts.Favorites){
                setState(() {
                  isFavoriteSelected = true;
                });
              }else{
                setState(() {
                  isFavoriteSelected = false;
                });
              }
            },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                 const PopupMenuItem(child:Text('Show Favorites'),value: selectedProducts.Favorites,),
                 const PopupMenuItem(child:Text('Show All'),value: selectedProducts.All ,),
              ],
          ),
          Consumer<Cart>(
            builder: (context , cartListener , ch) =>
                Badge(
                  child: ch,
                  value: cartListener.itemCount.toString(),),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: (){
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: buildDrawer(dTitle: 'Sections' ,backButton: false ,context: context),
      body: ProductsGrid(isFavoriteSelected),
    );
  }
}
