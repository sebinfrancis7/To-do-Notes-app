import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:to_do_application/screens/email_signup.dart';
import 'package:to_do_application/screens/phone_signin.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 80),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  './assets/icon/logo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Text(
                "Login",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 25),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "E-mail",
                  hintText: "Write E-mail Here",
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
              margin: EdgeInsets.fromLTRB(30, 20, 30, 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[800],
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onPressed: () {
                  _signIn();
                },
                child: Center(
                  child: Text("Login with E-mail"),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[800],
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EmailSignupScreen()));
                },
                child: Center(
                  child: Text("Sign-Up using E-mail"),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  "OR",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Wrap(
                children: <Widget>[
                  TextButton.icon(
                      onPressed: () {
                        _signInGoogle();
                      },
                      icon: Icon(
                        Icons.g_translate,
                        color: Colors.red,
                      ),
                      label: Text(
                        "Sign-In with Google",
                        style: TextStyle(color: Colors.red),
                      )),
                  SizedBox(
                    width: 25,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhoneSignIn()));
                    },
                    icon: Icon(Icons.local_phone_outlined),
                    label: Text(
                      "Sign-In using Phone",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    String emailText = _emailController.text.trim();
    String passwordText = _passwordController.text;

    if (emailText.isNotEmpty && passwordText.isNotEmpty) {
      _auth
          .signInWithEmailAndPassword(email: emailText, password: passwordText)
          .then((user) => {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Success"),
                        content: Text("Login Successful"),
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
          .catchError((e) {
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
                        Navigator.of(context).pop();
                      },
                      child: Text("OK")),
                ],
              );
            });
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Please provide E-mail and Password"),
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
                      Navigator.of(context).pop();
                    },
                    child: Text("OK")),
              ],
            );
          });
    }
  }

  void _signInGoogle() async {
    try {
      await _googleSignIn.signIn();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Successfully logged-in with Google"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK")),
              ],
            );
          });
    } catch (error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("$error"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK")),
              ],
            );
          });
    }
  }
}
