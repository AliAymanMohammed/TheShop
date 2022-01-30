import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theshop/Animated%20Routes/custom_route.dart';
import 'package:theshop/Providers/authentication.dart';

import '../Screens/products_overview_screen.dart';
import '../Screens/user_products_screen.dart';
import '../Screens/orders_screen.dart';
import 'Screens/auth_screen.dart';

Widget buildDrawer(
        {@required String dTitle,
        bool backButton = false,
        BuildContext context}) =>
    Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(dTitle),
            automaticallyImplyLeading: backButton,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text(
              'Shop',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, ProductsOverViewScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text(
              'Orders',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              // Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
              Navigator.of(context).pushReplacement(
                  CustomRoute(builder: (context) => OrdersScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text(
              'Manage Products',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, UserProductScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              'Log Out',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(AuthScreen.routeName);
              Provider.of<Auth>(context ,listen: false).logOut();
            },
          ),
        ],
      ),
      elevation: 8,
    );

// custom TextForm
