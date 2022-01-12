import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../Providers/authentication.dart';
import '../Providers/cart.dart';
import '../Models/products.dart';
import '../Screens/product_detail_screen.dart';
class ProductItem extends StatelessWidget {
  // final String pId;
  // final String pTitle;
  // final String pImageUrl;
  // ProductItem({
  //   @required this.pId,
  //   @required this.pTitle,
  //   @required this.pImageUrl,
  // });
  @override
  Widget build(BuildContext context) {
    final productModelProvider = Provider.of<Product>(context , listen: false);
    final cartProvider = Provider.of<Cart>(context , listen: false);
    final authListener = Provider.of<Auth>(context , listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Hero(
            tag: productModelProvider.id ,
            child: Image.network(
              productModelProvider.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          onTap: (){
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments:productModelProvider.id);
          },
        ),
        footer: GridTileBar(
          backgroundColor:Colors.brown.withOpacity(0.87),
          leading: Consumer<Product>(
            builder: (context , product , child) => IconButton(
                onPressed: () {
                  product.toggleFavorite(authListener.authToken , authListener.userID);
                },
                icon:  Icon( product.isFavorite ?
                Icons.favorite :Icons.favorite_border, color:Colors.deepOrange)),
          ),
          title: Text(productModelProvider.title),
          trailing:
              IconButton(
                  onPressed: () {
                    cartProvider.addItem(productModelProvider.id, productModelProvider.title, productModelProvider.price);
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(
                        SnackBar(
                            content: const Text('Added to cart' , style: TextStyle(fontSize: 18 ,color: Colors.black),),
                          elevation: 5,
                          backgroundColor:Theme.of(context).primaryColor,
                          duration: const Duration(seconds: 2,),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: (){
                              cartProvider.removeSingleItem(productModelProvider.id);
                            },
                          ),
                        ),);
                  },
                  icon:  Icon(Icons.shopping_cart,color: Theme.of(context).accentColor,)),
        ),
      ),
    );
  }
}
