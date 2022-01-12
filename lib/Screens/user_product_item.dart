import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theshop/Providers/product_provider.dart';

import '../Screens/edit_products.dart';

class UserProductItemScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  UserProductItemScreen({
    this.title,
    this.imageUrl,
    this.id
});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 30,
            ),
            title: Text(title),
            trailing: Container(
              width: 100,
              child: Row(
                children: [
                  IconButton(onPressed: (){
                    Navigator.of(context).pushNamed(EditProductsScreen.routeName , arguments:id);
                  },
                    icon: Icon(Icons.edit),splashColor: Colors.brown,),
                  IconButton(onPressed: () async{
                   try{
                    await Provider.of<ProductProvider>(context ,listen: false).deleteProduct(id);
                   }catch(error){
                     scaffold.showSnackBar(SnackBar(content: Text('Delete Failed'),),);
                     throw error;
                   }
                  }, icon: Icon(Icons.delete , color: Theme.of(context).errorColor,),splashColor: Colors.red),
                ],
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
