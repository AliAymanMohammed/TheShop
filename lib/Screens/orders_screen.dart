import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/build_order_item.dart';
import '../Providers/orders.dart';
import '../components.dart';

class OrdersScreen extends StatelessWidget{
  static const String routeName = '/orders-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: buildDrawer(dTitle: 'Sections' ,backButton: false ,context: context),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false ).getOrders(),
        builder: (context , snapShot) {
         if(snapShot.connectionState == ConnectionState.waiting){
           return const Center(child: CircularProgressIndicator(),);
         }else{
           if(snapShot.error != null){
             return Center(child: Text('Error'),);
           }else{
             return Consumer<Orders>(
               builder: (context ,ordersProvider , child ) => ListView.builder(
                 itemBuilder: (context , index) => BuildOrderItem(ordersProvider.orders[index]),
                 itemCount:ordersProvider.orders.length,
               ),
             );
           }
         }
        }
      ),
    );
  }
}
// this code will run normally
//    isLoading = true;
// Provider.of<Orders>(context, listen: false ).getOrders().then((_){
//   setState(() {
//     isLoading = false;
//   });}
// );