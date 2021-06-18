import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmailSignupScreen extends StatefulWidget {
  @override
  _EmailSignupScreenState createState() => _EmailSignupScreenState();
}

final TextEditingController _emailController = TextEditingController();

final TextEditingController _passwordController = TextEditingController();

final TextEditingController _passwordControllerFinal = TextEditingController();

final FirebaseAuth _auth = FirebaseAuth.instance;

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class _EmailSignupScreenState extends State<EmailSignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            padding: EdgeInsets.only(left: 65), child: Text("Email Sign-Up ")),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 30),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    hintText: "Write Email Here",
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 5),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: "Write Password Here",
                  ),
                  obscureText: true,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 5),
                child: TextField(
                  controller: _passwordControllerFinal,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Confirm Password",
                    hintText: "Re-Write Password Here",
                  ),
                  obscureText: true,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[800],
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  onPressed: () {
                    _signUp();
                  },
                  child: Center(
                    child: Text("Sign-Up using Email"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() {
    String emailText = _emailController.text.trim();
    String passwordText = _passwordController.text;
    String finalPasswordText = _passwordControllerFinal.text;

    if (emailText.isNotEmpty &&
        passwordText.isNotEmpty &&
        finalPasswordText.isNotEmpty) {
      if (passwordText == finalPasswordText) {
        _auth
            .createUserWithEmailAndPassword(
                email: emailText, password: passwordText)
            .then((user) => {
                  // firestore.collection("users").add(data);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Success"),
                          content: Text("Account has been created"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("OK")),
                          ],
                        );
                      })
                })
            .catchError((e) => {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text("${e.message}"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  _emailController.text = "";
                                  _passwordController.text = "";
                                  _passwordControllerFinal.text = "";
                                  Navigator.of(context).pop();
                                },
                                child: Text("OK")),
                          ],
                        );
                      })
                });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("Password Confirmation and Password must match"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        _emailController.text = "";
                        _passwordController.text = "";
                        _passwordControllerFinal.text = "";
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel")),
                ],
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Please provide E-mail and Password"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
              ],
            );
          });
    }
  }
}
