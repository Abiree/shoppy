import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppy/widgets/Custom_action_bar.dart';
import 'package:shoppy/services/firebase_services.dart';
import 'package:shoppy/screens/product_page.dart';
import '../Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SavedTab extends StatefulWidget {
  @override
  _SavedTab createState() => _SavedTab();
}

class _SavedTab extends State<SavedTab>{

 final CollectionReference _productsRef = FirebaseFirestore.instance.collection("users");

  FirebaseServices _firebaseServices = FirebaseServices();
  
  
/*
String getUserId() {
    return _firebaseAuth.currentUser!.uid;
  }

 FutureBuilder<QuerySnapshot>(
            
            future: _firebaseServices.usersRef
                .doc(_firebaseServices.getUserId())
                .collection("Cart")
                .get(), */
                /*
_productsRef 
    .doc('some_id') // <-- Doc ID to be deleted. 
    .delete() // <-- Delete
    .then((_) => print('Deleted'))
    .catchError((error) => print('Delete failed: $error'));
    */


  Future _RemoveFromSave(id) {
    print("userid"+_firebaseServices.getUserId());
    print("docid"+id);
    return FirebaseFirestore.instance.collection("Users").doc(_firebaseServices.getUserId()).collection("Save").doc(id).delete();
  }

  final SnackBar _snackBarCart = SnackBar(
    content: Text("Removed"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            
            future: _firebaseServices.usersRef
                .doc(_firebaseServices.getUserId())
                .collection("Save")
                .get(),
            builder: (context, snapshot) {
             
              
              print("${_firebaseServices.getUserId()}");
              print("builder");
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }
              //Collection Data ready to display
              if (snapshot.connectionState == ConnectionState.done) {
                print("im here");
                print("data lenght ${snapshot.data!.docs.length}");

                //Display data inside a list view
                return ListView(
                  padding: EdgeInsets.only(
                    top: 108.0,
                    bottom: 12.0,
                  ),
                  children: snapshot.data!.docs.map((document) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                productId: document.id,
                              ),
                            ));
                      },
                      child: Row(
                        children: [
                          Expanded(
                            flex : 9,
                            child : FutureBuilder<DocumentSnapshot>(
                            future: _firebaseServices.productsRef
                                .doc(document.id)
                                .get(),
                            builder: (context, productSnap) {
                              if (productSnap.hasError) {
                                return Container(
                                  child: Center(
                                    child: Text("${productSnap.error}"),
                                  ),
                                );
                              }
                              if (productSnap.connectionState ==
                                  ConnectionState.done) {
                                print('im in the connection state condition true');
                                Map<String, dynamic> _productMap = productSnap.data!
                                    .data() as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 24.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 90,
                                        height: 90,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Image.network(
                                            "${_productMap['images'][0]}",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 16.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${_productMap['name']}",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 4.0,
                                              ),
                                              child: Text(
                                                "\$${_productMap['price']}",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            Text(
                                              "Size - ${document['size']}",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          flex : 1,
                          child : GestureDetector(
                         onTap: () async {
                                await _RemoveFromSave(document.id);
                                Scaffold.of(context).showSnackBar(_snackBarCart);
                              },
                          child: Container(
                                  height: 30.0,
                                  margin: EdgeInsets.only(
                                    right: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "X",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                            ),
                         )
                        )
                      ],
                      ),
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
            hasBackArrow: false,
            title: "Saved",
          )
        ],
      ),
    );
  }

}