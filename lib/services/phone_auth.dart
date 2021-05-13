import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuth {
  static final _auth = FirebaseAuth.instance;
  static PhoneAuthCredential _phoneAuthcredential;
  static String _verificationId;

  static void _verificationCompleted(
      PhoneAuthCredential phoneAuthCredential, TextEditingController pinOtp) {
    _phoneAuthcredential = phoneAuthCredential;
    pinOtp.text = _phoneAuthcredential.smsCode;
  }

  static void _verificationFailed(
      FirebaseAuthException error, BuildContext context) {
    if (error.code == 'invalid-phone-number') {
      _showSnackBarAndPopScreen(context, 'Invalid Phone Number');
    }
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
            _verificationCompleted(phoneAuthCredential, pinOtp),
        verificationFailed: (error) => _verificationFailed(error, context),
        codeSent: _codeSent,
        codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout);
  }

  static void verifyOtp(String code, BuildContext context) async {
    _phoneAuthcredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: code);
    _auth
        .signInWithCredential(_phoneAuthcredential)
        .then((userCredential) => Navigator.of(context).pop())
        .catchError(() {
      _showSnackBarAndPopScreen(context, 'Verification Not Successful');
    });
  }

  static void logout() {
    _auth.signOut();
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
  }
}
