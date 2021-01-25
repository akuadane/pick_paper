import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pick_paper/handlers/firebase_auth_helper.dart';
import 'package:pick_paper/screens/login.dart';

import 'home.dart';

class Index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return Home(FirebaseAuth.instance.currentUser.uid);
    } else {
      return LogIn();
    }
  }
}
