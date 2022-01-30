import 'dart:convert';

import 'package:flutter/material.dart';
import '/Providers/cart.dart';
import 'package:http/http.dart' as http;


class Orders with ChangeNotifier{

  final String token;
  final String userId;
  Orders({
    this.token = '',
    this.allOrders = const [],
    this.userId,
});

   List<OrderItem>  allOrders = [];


  List<OrderItem> get orders{
    return [...allOrders];
  }


  Future<void> addOrder({
    @required List<CartItem> cartProducts ,
    @required double total
}) async {
    final timeStamp = DateTime.now();
    final url = Uri.parse('https://the-shop-9a31e-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');
    final response =  await http.post(url ,
        body: json.encode({
      'OAmount' : double.parse(total.toString()),
      'dateTime' : timeStamp.toIso8601String(),
      'oProducts' : cartProducts.map((cI) => {
          'cId' : cI.cId,
          'cTitle' : cI.cTitle,
          'cPrice' : cI.cPrice,
          'cQuantity' : cI.cQuantity,
        }).toList(),
     }));
    allOrders.insert(0,OrderItem(oId: json.decode(response.body)['name'], oAmount: total, oProducts: cartProducts, dateTime: timeStamp));
    notifyListeners();
  }
  Future<void> getOrders() async{
    final url = Uri.parse('https://the-shop-9a31e-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');
      final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String ,dynamic>;
    if(extractedData == null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
            oId: orderId,
            oAmount: double.parse(orderData['OAmount'].toString()),
            dateTime: DateTime.parse(orderData['dateTime']),
          oProducts: (orderData['oProducts'] as List<dynamic>).map((item) =>
              CartItem(
                  cId: item['cId'].toString(),
                  cTitle: item['cTitle'],
                  cPrice: item['cPrice'],
                  cQuantity: item['cQuantity']),).toList()
        ),
      );
    });
      allOrders = loadedOrders.reversed.toList();
      notifyListeners();
  }
}

class OrderItem{
  final String oId;
  final double oAmount;
  final List<CartItem> oProducts;
  final DateTime dateTime;

  OrderItem({
    @required this.oId,
    @required this.oAmount,
    @required this.oProducts,
    @required this.dateTime,
});

}