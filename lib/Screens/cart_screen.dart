import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:theshop/Models/products.dart';
import 'package:theshop/Providers/orders.dart';
import 'package:theshop/Screens/orders_screen.dart';

import '../Providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    var cartListener = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            color: HexColor('#efc9af'),
            elevation: 5,
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total :',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '${cartListener.totalAmount} EGP',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.subtitle1.color,
                      ),
                    ),
                  ),
               OrderButton(cartListener: cartListener),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => buildCartItem(
                productId: cartListener.items.keys.toList()[index],
                title: cartListener.items.values.toList()[index].cTitle,
                id: cartListener.items.values.toList()[index].cId.toString(),
                price:double.parse( cartListener.items.values.toList()[index].cPrice.toString()),
                quantity: int.parse(cartListener.items.values.toList()[index].cQuantity.toString()),
                context: context
              ),
              itemCount: cartListener.itemCount,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCartItem({
    @required String id,
    @required String productId,
    @required String title,
    @required double price,
    @required int quantity,
    BuildContext context,
  }) =>
      Consumer<Cart>(
        builder: (context , listener , child) =>Dismissible(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: FittedBox(child: Text('$price')),
                ),
                title: Text(title),
                subtitle: Text('Total : ${price * quantity} EGP'),
                trailing: Chip(label: Text('$quantity X')),
              ),
            ),
            elevation: 5,
            color: HexColor('#efc9af'),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          ),
          key: ValueKey(id),
          background: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              color: Theme.of(context).errorColor,
              alignment: Alignment.centerRight,
              child: const Icon(Icons.delete , color: Colors.white,size: 40,),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            ),
          ),
          confirmDismiss: (direction){
            return showDialog(context: context, builder:(context) => AlertDialog(
              title: const Text('Are You Sure ?'),
              content: const Text('This item will be deleted from the cart'),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                FlatButton(onPressed: (){
                  Navigator.of(context).pop(false);
                }, child: const Text('No')),
                FlatButton(onPressed: (){
                  Navigator.of(context).pop(true);
                }, child: const Text('Yes')),
              ],

              elevation: 5,
            ),);
          },
          direction: DismissDirection.endToStart,
          onDismissed: (direction){
            listener.deleteCartItem(productId);
          },
        ),
      );
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartListener,
  }) : super(key: key);

  final Cart cartListener;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cartListener.totalAmount <= 0 || isLoading) ? null : () async{
        setState(() {
          isLoading = true;
        });
         await Provider.of<Orders>(context , listen: false).addOrder(cartProducts: widget.cartListener.items.values.toList(), total: widget.cartListener.totalAmount);
         setState(() {
           isLoading = false;
         });
        widget.cartListener.clear();
      },
      child: isLoading ? const Center(child: CircularProgressIndicator(),) : const Text(
        ' ORDER NOW',
        style: TextStyle(
          color: Colors.deepOrange,
        ),
      ),
      splashColor: Colors.brown.withOpacity(0.6),
    );
  }
}
