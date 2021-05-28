import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loja_importacao/helpers/class_helpers.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Novidades"),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection("home")
                    .orderBy("pos")
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return SliverToBoxAdapter(
                      child: Container(
                        alignment: Alignment.center,
                        height: 200,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  else {
                    return SliverStaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        staggeredTiles: snapshot.data!.docs.map((doc) {
                          return StaggeredTile.count(
                              doc.data()["x"], doc.data()["y"] + 0.0);
                        }).toList(),
                        children: snapshot.data!.docs.map((doc) {
                          return FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: doc.data()["image"],
                            fit: BoxFit.cover,
                          );
                        }).toList());
                  }
                })
          ],
        )
      ],
    );
  }
}
