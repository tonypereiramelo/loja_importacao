import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:loja_importacao/datas/cart_product.dart';
import 'package:loja_importacao/datas/product_data.dart';
import 'package:loja_importacao/models/cart_model.dart';
import 'package:loja_importacao/models/user_model.dart';
import 'package:loja_importacao/screens/cart_screen.dart';
import 'package:loja_importacao/screens/login_screen.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;
  ProductScreen(this.product);
  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;
  String? color;
  _ProductScreenState(this.product, {this.color});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title.toString()),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: CarouselSlider(
              options: CarouselOptions(height: 400),
              items: product.images!.map((url) {
                return CachedNetworkImage(
                  imageUrl: url,
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toString()}",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Cor",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.5),
                    children: product.color!.map((c) {
                      return GestureDetector(
                        onTap: () {
                          color = c;
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                  color:
                                      c == color ? primaryColor : Colors.grey,
                                  width: 3)),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(c),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                      child: Text(UserModel.of(context).isLoggedIn()
                          ? "Adicionar ao Carrinho"
                          : "Entre para Comprar!"),
                      style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                          onPrimary: Colors.white,
                          textStyle: TextStyle(fontSize: 18)),
                      onPressed: color != null
                          ? () {
                              if (UserModel.of(context).isLoggedIn()) {
                                CartProduct cartProduct = CartProduct();
                                cartProduct.color = color;
                                cartProduct.quantity = 1;
                                cartProduct.pid = product.id;
                                cartProduct.category = product.category;
                                cartProduct.productData = product;

                                CartModel.of(context).addCartItem(cartProduct);

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CartScreen()));
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                              }
                            }
                          : null),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Descrição",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  product.description.toString(),
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
