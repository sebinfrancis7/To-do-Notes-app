import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneSignIn extends StatefulWidget {
  @override
  _PhoneSignInState createState() => _PhoneSignInState();
}

PhoneNumber _phoneNumber;
String _message;
String _verificationId;
bool _isOtpSent = false;

final FirebaseAuth _auth = FirebaseAuth.instance;
final TextEditingController _otpController = TextEditingController();

class _PhoneSignInState extends State<PhoneSignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            padding: EdgeInsets.only(left: 65), child: Text("Phone Sign-In ")),
      ),
      body: SingleChildScrollView(
          child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        margin: EdgeInsets.only(top: 80),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: InternationalPhoneNumberInput(
                onInputChanged: (number) {
                  _phoneNumber = number;
                },
                countries: ['IN', 'US', 'NZ'],
                inputBorder: OutlineInputBorder(),
              ),
            ),
            _isOtpSent
                ? Container(
                    child: TextField(
                      controller: _otpController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter OTP here",
                        labelText: "OTP",
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),
                  )
                : Container(),
            _isOtpSent
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey[800],
                        onPrimary: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      onPressed: () {
                        _verifyPhoneNumber();
                      },
                      child: Center(
                        child: Text("Verify OTP"),
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey[800],
                        onPrimary: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isOtpSent = true;
                        });
                      },
                      child: Center(
                        child: Text("Send OTP"),
                      ),
                    ),
                  ),
          ],
        ),
      )),
    );
  }

  void _verifyPhoneNumber() async {
    setState(() {
          _message = "";
        });

    final PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed = (FirebaseAuthException e) async {
          if (e.code == 'invalid-phone-number') {
            setState(() {
                    
                        });
    }
    };

    final PhoneCodeSent codeSent = (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
    };

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
  } 
}
