import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pick_paper/models/shared_user.dart';
import 'package:pick_paper/screens/verify_otp.dart';
import 'package:provider/provider.dart';

class FirebaseAuthHelper {
  static final _authInstance = FirebaseAuth.instance;

  static Future<UserCredential> signInWithPhone(
      String phoneNumber, BuildContext context) async {
    _authInstance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (AuthCredential credential) async {
        UserCredential userCredential =
            await _authInstance.signInWithCredential(credential);

        return userCredential;
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int forceResendToken) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpPage(
              phoneNumber: phoneNumber,
              verificationId: verificationId,
              forceResendToken: forceResendToken,
            ),
          ),
        );

        print("Code sent");
      },
      codeAutoRetrievalTimeout: (message) {
        print("From auto code retrival");
        print(message);
      },
      timeout: Duration(seconds: 60),
    );
  }

  static Future<UserCredential> signInWithOtp(
      String verificationId, String otp, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);

      UserCredential userCredential =
          await _authInstance.signInWithCredential(credential);

      return userCredential;
    } catch (e) {
      return null;
    }
  }

  static logout() {
    _authInstance.signOut();
  }
}
