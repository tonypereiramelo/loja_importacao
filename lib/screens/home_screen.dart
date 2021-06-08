import 'package:flutter/material.dart';
import 'package:loja_importacao/tabs/home_tab.dart';
import 'package:loja_importacao/tabs/orders_tab.dart';
import 'package:loja_importacao/tabs/places_tb.dart';
import 'package:loja_importacao/tiles/products_tab.dart';
import 'package:loja_importacao/widgets/cart_button.dart';
import 'package:loja_importacao/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Loja"),
            centerTitle: true,
          ),
          body: PlacesTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus Pedidos"),
            centerTitle: true,
          ),
          body: OdersTab(),
          drawer: CustomDrawer(_pageController),
        )
      ],
    );
  }
}
