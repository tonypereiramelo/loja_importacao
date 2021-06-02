import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_importacao/datas/cart_product.dart';
import 'package:loja_importacao/datas/product_data.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;
  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      return Row();
    }

    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: cartProduct.productData == null
            ? FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection("products")
                    .doc(cartProduct.category)
                    .collection("items")
                    .doc(cartProduct.pid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    cartProduct.productData =
                        ProductData.fromDocument(snapshot.data!);
                    return _buildContent();
                  } else {
                    return Container(
                      height: 70,
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                    );
                  }
                },
              )
            : _buildContent());
  }
}
