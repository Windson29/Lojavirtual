import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojadomdiegoapp/models/product.dart';
import 'package:lojadomdiegoapp/models/product_manager.dart';
import 'package:lojadomdiegoapp/models/user_manager.dart';
import 'package:lojadomdiegoapp/screens/base/base_screen.dart';
import 'package:lojadomdiegoapp/screens/cart/cart_screen.dart';
import 'package:lojadomdiegoapp/screens/login/login_screen.dart';
import 'package:lojadomdiegoapp/screens/screen_product/product_screen.dart';
import 'package:lojadomdiegoapp/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';

import 'models/cart_manager.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager)
            => cartManager..updateUser(userManager),
        ),
      ],
      child: MaterialApp(
        title: 'Loja - Dom Diego',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 95, 158, 160),
          scaffoldBackgroundColor: const Color.fromARGB(255, 0, 128, 128),

          //visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/base',
        onGenerateRoute: (settings){
          switch(settings.name){
            case '/login':
              return MaterialPageRoute(
                  builder: (_) => LoginScreen()
              );
            case '/signup':
            return MaterialPageRoute(
                builder: (_) => SignUpScreen()
            );
            case '/product':
              return MaterialPageRoute(
                  builder: (_) => ProductScreen(
                    settings.arguments as Product
                  )
              );
            case '/cart':
              return MaterialPageRoute(
                  builder: (_) => CartScreen()
              );
            case '/base':
            default:
              return MaterialPageRoute(
                builder: (_) => BaseScreen()
              );
          }
        },
      ),
    );
  }
}

