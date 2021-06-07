import 'package:flutter/material.dart';
import 'package:loja_importacao/models/cart_model.dart';
import 'package:loja_importacao/models/user_model.dart';
import 'package:loja_importacao/screens/login_screen.dart';
import 'package:loja_importacao/tiles/cart_tile.dart';
import 'package:loja_importacao/widgets/cart_price.dart';
import 'package:loja_importacao/widgets/discount_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 9),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int p = model.products.length;
                String _quantity = "";
                if (p == 1) {
                  _quantity = " ITEM";
                } else if (p > 1) {
                  _quantity = "ITENS";
                }
                return Text(
                  "$p $_quantity",
                  style: TextStyle(fontSize: 16),
                );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isLoggedIn()) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Faça Login para adicionar produtos!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                    child: Text("Entrar"),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      onPrimary: Colors.white,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            );
          } else if (model.products.length == 0) {
            return Center(
              child: Text(
                "Nenhum produto adicionado!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  children: model.products.map((product) {
                    return CartTile(product);
                  }).toList(),
                ),
                DiscountCard(),
                CartPrice(() async {
                  String? orderId = await model.finishOrder();
                  if (orderId != null) {
                    print(orderId);
                  }
                })
              ],
            );
          }
        },
      ),
    );
  }
}
