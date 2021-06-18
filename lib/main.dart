import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do_application/screens/login_screen.dart';

// com.to_do_app.app firbase app id
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
    theme: ThemeData(
      primaryColor: Colors.grey[700],
      brightness: Brightness.light,
    ),
    darkTheme: ThemeData(
      primaryColor: Colors.white,
      brightness: Brightness.dark,
    ),
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginScreen(),
      // appBar: AppBar(
      //   title: Text("TO-DO LIST"),
      //   centerTitle: true,
      // ),
    );
  }
}
