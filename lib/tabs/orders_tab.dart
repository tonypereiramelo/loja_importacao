import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_importacao/models/user_model.dart';
import 'package:loja_importacao/screens/login_screen.dart';
import 'package:loja_importacao/tiles/order_tile.dart';

class OdersTab extends StatelessWidget {
  const OdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String? uid = UserModel.of(context).user!.uid;

      return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection("orders")
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              return ListView(
                children: snapshot.data!.docs
                    .map((doc) => OrderTile(doc.id))
                    .toList()
                    .reversed
                    .toList(),
              );
            }
          });
    } else {
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.view_list,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Faça Login para acompanhar!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
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
    }
  }
}
