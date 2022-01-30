import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:theshop/notificationservice.dart';
import 'package:theshop/shared_pref.dart';

import '../Screens/waiting_screen.dart';
 import './Screens/edit_products.dart';
import './Screens/orders_screen.dart';
import './Screens/user_products_screen.dart';
import './Providers/orders.dart';
import './Screens/cart_screen.dart';
import './Providers/cart.dart';
import './Providers/product_provider.dart';
import './Screens/product_detail_screen.dart';
import './Screens/products_overview_screen.dart';
import './Screens/auth_screen.dart';
import './Providers/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await CacheHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth , ProductProvider>(
            create: (context) => ProductProvider(),
            update: (context , authListener , productListener) =>
                ProductProvider(
                    token:authListener.authToken,
                    items:productListener == null ? [] : productListener.Products,userId: authListener.userID),),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth , Orders>(
            create: (context) => Orders(),
            update: (context ,authListener , ordersListener) =>
                Orders(token: authListener.authToken ,
                    allOrders: ordersListener == null ? [] : ordersListener.orders , userId: authListener.userID),)
      ],
      child: Consumer<Auth>(
        builder: (context, authListener, _ ) => MaterialApp(
          title: 'The Shop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.brown,
              canvasColor: HexColor('#f2bc94'),
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato'),
          home: authListener.isAuth ? ProductsOverViewScreen() :
          FutureBuilder(
            future: authListener.tryLogin(),
            builder:(context , snapShot) => snapShot.connectionState == ConnectionState.waiting ? WaitingScreen():AuthScreen(),),
          routes: {
            AuthScreen.routeName: (context) => AuthScreen(),
            ProductsOverViewScreen.routeName: (context) => ProductsOverViewScreen(),
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductScreen.routeName: (context) => UserProductScreen(),
            EditProductsScreen.routeName: (context) => EditProductsScreen(),
          },
        ),
      ),
    );
  }
}
