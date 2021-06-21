import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_application/screens/home_screen.dart';
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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Center(child: Text("TO-DO APP")),
        ),
      ),
      body: StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState != ConnectionState.active) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 5,
                ),
              );
            }
            final user = snapshot.data;
            if (user != null) {
              return HomeScreen(currentUser: user);
            } else {
              return LoginScreen();
            }
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}


  


  // Container(
            //   margin: EdgeInsets.fromLTRB(250, 20, 10, 10),
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       primary: Colors.grey[700],
            //       onPrimary: Colors.white,
            //       padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
            //       shape: const RoundedRectangleBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(10)),
            //       ),
            //     ),
            //     onPressed: () {
            //       _auth.signOut();
            //     },
            //     child: Center(
            //       child: Text(
            //         "Log-Out",
            //         style: TextStyle(color: Colors.red),
            //       ),
            //     ),
            //   ),
            // ),