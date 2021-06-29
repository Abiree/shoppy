import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppy/Constants.dart';
import 'package:shoppy/screens/RegisterPage.dart';
import 'package:shoppy/widgets/CustomButton.dart';
import 'package:shoppy/widgets/CustomInput.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Build a alert dialog to display errors
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Container(
            child: Text(error),
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  // login to account
  Future<String?> _loginAccount() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'The email that you\'ve entered is incorrect.';
      } else if (e.code == 'wrong-password') {
        return 'The password that you\'ve entered is incorrect.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submit() async {
    // set state to loading state
    setState(() {
      _isLoading = true;
    });

    String? _feedback = await _loginAccount();
    if (_feedback != null) {
      // we got errors
      _alertDialogBuilder(_feedback);

      // set the state to regular
      setState(() {
        _isLoading = false;
      });
    }
  }

  //Default Register Form Loading State
  bool _isLoading = false;

  //Default Input Fields Values
  String _email = "";
  String _password = "";

  // FocusNode for Input fields
  FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 25,
                ),
                child: Text(
                  "Welcome to Shoppy, \nLogin to your account",
                  textAlign: TextAlign.center,
                  style: Constants.boldHeading,
                ),
              ),
              Column(
                children: [
                  CustomInput(
                    hintText: "Email Address",
                    onChanged: (value) {
                      _email = value;
                    },
                    onSubmitted: (value) {
                      _passwordFocusNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  CustomInput(
                    hintText: "Password",
                    onChanged: (value) {
                      _password = value;
                    },
                    onSubmitted: (value) {
                      _submit();
                    },
                    focusNode: _passwordFocusNode,
                    isPasswordField: true,
                  ),
                  CustomButton(
                      text: "Log In",
                      onPressed: () {
                        _submit();
                      },
                      isLoading: _isLoading)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CustomButton(
                  text: "Create New Account",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                      ),
                    );
                  },
                  outlineButton: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
