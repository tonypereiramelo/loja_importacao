import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String? category;
  String? id;
  String? title;
  String? description;
  double? price;
  List? color;
  List? images;

  ProductData.fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    id = snapshot.id;
    title = snapshot.data()!["title"];
    description = snapshot.data()!["description"];
    price = snapshot.data()!["price"] + 0.0;
    color = snapshot.data()!["color"];
    images = snapshot.data()!["images"];
  }
  Map<String, dynamic> toResumedMap() {
    return {
      "title": title,
      "description": description,
      "price": price,
    };
  }
}
