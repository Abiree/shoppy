import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppy/Constants.dart';
import 'package:shoppy/screens/product_page.dart';
import 'package:shoppy/services/firebase_services.dart';
import 'package:shoppy/widgets/CustomInput.dart';
import 'package:shoppy/widgets/product_card.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final FirebaseServices _firebaseServices = FirebaseServices();
  String _searchString = "";
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        if(_searchString.isEmpty)
       Center( 
         child: Container(
          
          child: Text("Search Results",
          style:Constants.regularDarkText,
          ),
          )
          )
        else
        FutureBuilder<QuerySnapshot>(
          future: _firebaseServices.productsRef
              .orderBy("search_string")
              .startAt([_searchString]).endAt(["$_searchString\uf8ff"]).get(),
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
                  top: 130.0,
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
        Padding(
          padding: const EdgeInsets.only(
            top: 45.0,
          ),
          child: CustomInput(
            hintText: "Search Here...",
            onSubmitted: (value) {
           
                setState(() {
                 _searchString = value.toLowerCase();
                });
              

            },
          ),
        ),
      ],
    ));
  }
}
