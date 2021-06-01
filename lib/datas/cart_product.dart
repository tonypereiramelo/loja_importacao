import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_importacao/datas/product_data.dart';

class CartProduct {
  String? cid;

  String? category;
  String? pid;

  int? quantity;
  String? color;

  ProductData? productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    cid = document.id;
    category = document.data()!["category"];
    pid = document.data()!["pid"];
    quantity = document.data()!["quantity"];
    color = document.data()!["color"];
  }
  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "pid": pid,
      "quantity": quantity,
      "color": color,
      //"product": productData!.toResumedMap()
    };
  }
}
