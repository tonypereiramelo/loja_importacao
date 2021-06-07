import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_importacao/datas/cart_product.dart';
import 'package:loja_importacao/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;
  List<CartProduct> products = [];

  String? couponCode;
  int discountPercentage = 0;

  bool isLoading = false;

  CartModel(this.user) {
    if (user.isLoggedIn()) _loadCartItems();
  }

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
    cartProduct.quantity = cartProduct.quantity! - 1;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.user!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity = cartProduct.quantity! + 1;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.user!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());

    notifyListeners();
  }

  void _loadCartItems() async {
    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.user!.uid)
        .collection("cart")
        .get();

    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }

  void setCoupon(String? couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  double? getProductsPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) price += (c.quantity! * c.productData!.price!);
    }
    return price;
  }

  double getDiscount() {
    return getProductsPrice()! * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  void updatePrice() {
    notifyListeners();
  }

  Future<String?> finishOrder() async {
    if (products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double? productPrice = getProductsPrice();
    double? shipPrice = getShipPrice();
    double? discount = getDiscount();

    DocumentReference refOrder =
        await FirebaseFirestore.instance.collection("orders").add({
      "clientId": user.user!.uid,
      "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
      "shipPrice": shipPrice,
      "discount": discount,
      "totalPrice": productPrice! + shipPrice - discount,
      "status": 1,
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.user!.uid)
        .collection("orders")
        .doc(refOrder.id)
        .set({"orderId": refOrder.id});

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.user!.uid)
        .collection("cart")
        .get();

    for (DocumentSnapshot doc in query.docs) {
      doc.reference.delete();
    }
    products.clear();
    couponCode = null;
    discountPercentage = 0;
    isLoading = false;
    notifyListeners();

    return refOrder.id;
  }
}
