import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shoppy/Constants.dart';
import 'package:shoppy/screens/HomePage.dart';
import 'package:shoppy/screens/LoginPage.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          // StreamBuilder checks the login state
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              // Check for errors
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${streamSnapshot.error}"),
                  ),
                );
              }

              // Connection state is active
              if (streamSnapshot.connectionState == ConnectionState.active) {
                //Get the user
                Object? _user = streamSnapshot.data;

                if (_user == null) {
                  //user not logged in
                  return LoginPage();
                } else {
                  //user logged in
                  return HomePage();
                }
              }

              // Checking the Auth state
              return Scaffold(
                body: Center(
                  child: Text(
                    "Checking Authentication...",
                    style: Constants.regularHeading,
                  ),
                ),
              );
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
          body: Center(
            child: Text(
              "Initializing App...",
              style: Constants.regularHeading,
            ),
          ),
        );
      },
    );
  }
}
