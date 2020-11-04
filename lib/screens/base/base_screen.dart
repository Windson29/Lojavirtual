import 'package:flutter/material.dart';
import 'package:lojadomdiegoapp/componentes/custom_drawer/custom_drawer.dart';
import 'package:lojadomdiegoapp/models/page_manager.dart';
import 'package:lojadomdiegoapp/screens/login/login_screen.dart';
import 'package:lojadomdiegoapp/screens/products/products_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: PageView(
        controller: pageController,
        children: <Widget>[
          Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(
              title: const Text('Home'),
            ),
          ),
          ProductsScreen(),
          Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(
              title: const Text('Home3'),
            ),
          ),
          Container(color: Colors.red,),
          Container(color: Colors.yellow,),
          Container(color: Colors.green,),
        ],
      ),
    );
  }
}
