import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_connect/main.dart';

class PhoneAuth {
  static final _auth = FirebaseAuth.instance;
  static PhoneAuthCredential _phoneAuthcredential;
  static String _verificationId;

  static void _verificationCompleted(PhoneAuthCredential phoneAuthCredential,
      TextEditingController pinOtp, BuildContext context) {
    _phoneAuthcredential = phoneAuthCredential;
    pinOtp.text = _phoneAuthcredential.smsCode;
    _login(context);
  }

  static void _verificationFailed(
      FirebaseAuthException error, BuildContext context) {
    if (error.code == 'invalid-phone-number') {
      _showSnackBarAndPopScreen(context, 'Invalid Phone Number');
    }
    _showSnackBarAndPopScreen(context, 'verification Failed');
    print('verification Failed');
    print(error.message);
  }

  static void _codeSent(String verificationId, int forceResendingToken) {
    _verificationId = verificationId;
  }

  static void _codeAutoRetrievalTimeout(String verificationId) {
    _verificationId = verificationId;
  }

  static Future<void> verifyNumber(String mobileNumber, BuildContext context,
      TextEditingController pinOtp) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: '+91 $mobileNumber',
        verificationCompleted: (phoneAuthCredential) =>
            _verificationCompleted(phoneAuthCredential, pinOtp, context),
        verificationFailed: (error) => _verificationFailed(error, context),
        codeSent: _codeSent,
        codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout);
  }

  static void verifyOtp(String code, BuildContext context) async {
    _phoneAuthcredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: code);
    _login(context);
  }

  static void logout(BuildContext context) async {
    print('logout');
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed(RoutingScreen.routeName);
  }

  static void _showSnackBarAndPopScreen(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(context).pop();
  }

  static void _login(BuildContext context) {
    _auth
        .signInWithCredential(_phoneAuthcredential)
        .then((value) =>
            Navigator.of(context).pushReplacementNamed(RoutingScreen.routeName))
        .catchError((error) {
      _showSnackBarAndPopScreen(context, 'Verification Not Successful');
    });
  }
}
