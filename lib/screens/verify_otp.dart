import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pick_paper/handlers/firebase_auth_helper.dart';
import 'package:pick_paper/handlers/firestore_helper.dart';
import 'package:pick_paper/models/shared_user.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class VerifyOtpPage extends StatelessWidget {
  final String phoneNumber;
  final String verificationId;

  final int forceResendToken;

  final _formKey = GlobalKey<FormState>();
  String _otp = "";

  VerifyOtpPage({this.phoneNumber, this.verificationId, this.forceResendToken});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "VERIFY",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Enter an OTP number sent to the number ${this.phoneNumber}",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.isEmpty) return "This can't be left empty!";
                        return null;
                      },
                      onSaved: (value) {
                        _otp = value.trim();
                      },
                      decoration: InputDecoration(
                        hintText: " OTP",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Builder(
                    builder: (BuildContext context) => InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        _submitForm(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "VERIFY",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Color(0XFF85FF40),
                                Color(0XFF0CE69C),
                              ],
                              begin: const FractionalOffset(0.0, 1.0),
                              end: const FractionalOffset(1.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(),
                ),
                Text("Terms and Conditions"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _submitForm(BuildContext context) async {
    final formState = _formKey.currentState;

    if (formState.validate()) {
      formState.save();

      showDialog(
          context: context,
          child: Center(
            child: CircularProgressIndicator(),
          ));

      UserCredential userCredential = await FirebaseAuthHelper.signInWithOtp(
          this.verificationId, this._otp, context);

      if (userCredential != null) {
        QuerySnapshot user =
            await FirestoreHelper.getUser(userCredential.user.uid);

        if (user.size == 0) {
          // creates a new account with the phone number if there is account registered to the phone number
          await FirestoreHelper.createUser(
              this.phoneNumber, userCredential.user.uid);

          //user = await FirestoreHelper.getUser(userCredential.user.uid);
        }

        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home(userCredential.user.uid)));
      } else {
        Navigator.pop(context);

        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Error signing in")));
      }
    }
  }
}
