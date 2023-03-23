import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';
import './screens/cart_screen.dart';
import './screens/product_page.dart';
import './screens/product_detail.dart';
import './provider/product_provider.dart';
import './provider/cart.dart';
import './provider/order.dart';
import './screens/order_screen.dart';
import './screens/user_product.dart';
import './screens/add_product.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './route/custom_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Product_Provider>(
            update: (context, auth, previous) => Product_Provider(
                auth.token, previous == null ? [] : previous.item, auth.userId),
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            update: (context, auth, previous) =>
                Order(auth.token, previous == null ? [] : previous.orderList),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
              title: 'MyShop',
              theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: Custom_Page_transition(),
                  TargetPlatform.iOS: Custom_Page_transition()
                }),
              ),
              home: auth.isAuth
                  ? Product_Page()
                  : FutureBuilder(
                      future: auth.autoLogin(),
                      builder: (context, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                Product_Detail.RouteName: (context) => Product_Detail(),
                Cart_Screen.RouteName: (context) => Cart_Screen(),
                Order_Screen.RouteName: (context) => Order_Screen(),
                User_Product.RouteName: (context) => User_Product(),
                Add_Product.RouteName: (context) => Add_Product(),
              }),
        ));
  }
}
