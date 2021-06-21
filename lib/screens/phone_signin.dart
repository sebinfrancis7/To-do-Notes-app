import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 30),
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
                        _verifyOtp();
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
                          _verifyPhoneNumber();
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

    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
      setState(() {
        _message = 'Received Phone Auth Credential: $credential';
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) async {
      if (e.code == 'invalid-phone-number') {
        setState(() {
          _message = 'Please provide a valid Phone Number';
        });
      } else {
        setState(() {
          _message =
              'Phone Number verification failed. Code: ${e.code}. Message: ${e.message}';
        });
      }
    };

    final PhoneCodeSent codeSent =
        (String verificationId, int resendToken) async {
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) async {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber.phoneNumber,
        timeout: Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _verifyOtp() async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _otpController.text);

    final authCredential = await _auth.signInWithCredential(credential);

    if (authCredential?.user != null) {
      setState(() {
        _message =
            'Successfully Signed-In. User ID: ${authCredential.user.uid}';
      });
      _firestore.collection("users").doc(authCredential.user.uid).set({
        "phone_number": authCredential.user.phoneNumber,
        "lastseen": DateTime.now(),
      });
    } else {
      setState(() {
        _message = 'Sign-In failed';
      });
    }
  }
}
