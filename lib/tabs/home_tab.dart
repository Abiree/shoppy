//import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shoppy/screens/product_page.dart';
import 'package:shoppy/widgets/Custom_action_bar.dart';
import 'package:shoppy/widgets/product_card.dart';

class HomeTab extends StatelessWidget {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection("Product");
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(children: [
      FutureBuilder<QuerySnapshot>(
        future: _productsRef.get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }
          //Collection Data ready to display
          if (snapshot.connectionState == ConnectionState.done) {
            //Display data inside a list view
            return ListView(
              padding: EdgeInsets.only(
                top: 108.0,
                bottom: 12.0,
              ),
              children: snapshot.data!.docs.map((document) {
                return ProductCard(
                  title: (document.data() as dynamic)['name'],
                  imageUrl: (document.data() as dynamic)['images'][0],
                  price: "\$${(document.data() as dynamic)['price']}",
                  productId: document.id,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductPage(
                                productId: document.id,
                              )),
                    );
                  },
                );
              }).toList(),
            );
          }
          //loading State
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      CustomActionBar(
        title: "Home",
        hasBackArrow: false,
      ),
    ]));
  }
}
