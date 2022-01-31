import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../Providers/orders.dart';

class BuildOrderItem extends StatefulWidget {
  final OrderItem orders;
  BuildOrderItem(this.orders);

  @override
  State<BuildOrderItem> createState() => _BuildOrderItemState();
}

class _BuildOrderItemState extends State<BuildOrderItem> {
  var isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: isExpanded ? min(widget.orders.oProducts.length * 20.0 + 110, 200) : 100 ,
      child: Card(
        color: HexColor('#cd7700'),
        margin: const EdgeInsets.all(10),
        elevation: 5,
        child: Column(
          children: [
            ListTile(
              title: Text('${widget.orders.oAmount.toString()} EGP'),
              subtitle: Text(DateFormat('dd / MM / yyyy  hh:mm')
                  .format(widget.orders.dateTime)),
              trailing: IconButton(
                icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
            ),
            // if (isExpanded)
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: isExpanded ? min(widget.orders.oProducts.length * 20.0 , 320.0) : 0,
                child: Container(
                  child: ListView(
                    children: [
                      ...(widget.orders.oProducts
                          .map(
                            (product) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               Row(
                                 children: [
                                   Text(
                                     '${product.cTitle} :',
                                     style: const TextStyle(
                                         fontSize: 18, fontWeight: FontWeight.bold),
                                   ),
                                   Text(
                                     ' ${product.cQuantity.toString()} , ${product.cPrice.toString()} EGP',
                                     style: const TextStyle(
                                         fontSize: 18, fontWeight: FontWeight.bold),
                                   ),
                                 ],
                               ),
                                Text(
                                  'Total :${product.cQuantity * product.cPrice}',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                          )
                          .toList()),
                    ],
                  ),
                  // height: min(widget.orders.oProducts.length * 20.0 + 20.0, 180.0),
                  margin: const EdgeInsets.symmetric(horizontal: 15 ,vertical: 4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
