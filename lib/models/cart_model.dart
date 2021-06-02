import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_importacao/datas/cart_product.dart';
import 'package:loja_importacao/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  int? quant;
  UserModel user;
  List<CartProduct> products = [];

  bool isLoading = false;

  CartModel(this.user);

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.user!.uid)
        .collection("cart")
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.id;
    });
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.user!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .delete();

    products.remove(cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    quant = cartProduct.quantity!;
    quant = quant! - 1;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.user!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct){
    quant = quant! + 1;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.user!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());

    notifyListeners();
  }
}
