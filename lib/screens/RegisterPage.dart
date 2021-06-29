import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppy/Constants.dart';
import 'package:shoppy/widgets/CustomButton.dart';
import 'package:shoppy/widgets/CustomInput.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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

  // create a new account
  Future<String?> _createAccount() async {
    if (_password != _confirmPassword) {
      return 'The passwords didn’t match.';
    }
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
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

    String? _feedback = await _createAccount();
    if (_feedback != null) {
      // we got errors
      _alertDialogBuilder(_feedback);

      // set the state to regular
      setState(() {
        _isLoading = false;
      });
    } else {
      // the user is logged in
      Navigator.pop(context);
    }
  }

  //Default Register Form Loading State
  bool _isLoading = false;

  //Default Input Fields Values
  String _email = "";
  String _password = "";
  String _confirmPassword = "";

  // FocusNode for Input fields
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _confirmPasswordFocusNode = FocusNode();

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
                  "Create A New Account",
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
                      _confirmPasswordFocusNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                    focusNode: _passwordFocusNode,
                    isPasswordField: true,
                  ),
                  CustomInput(
                    hintText: "Confirm Password",
                    onChanged: (value) {
                      _confirmPassword = value;
                    },
                    onSubmitted: (value) {
                      _submit();
                    },
                    focusNode: _confirmPasswordFocusNode,
                    isPasswordField: true,
                  ),
                  CustomButton(
                    text: "Create New Account",
                    onPressed: () {
                      _submit();
                    },
                    isLoading: _isLoading,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CustomButton(
                  text: "Back To Login",
                  onPressed: () {
                    Navigator.pop(context);
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
