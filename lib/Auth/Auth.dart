import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reel_app/home_screen/home_screen_ui.dart';
import 'package:reel_app/login_screen/login_screen_ui.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser != null) {
      print("LoginDetails yes");
      //print(auth.currentUser);
      return const HomeScreen();
    } else {
      print("LoginDetails null");
      //print(auth.currentUser);
      return const LoginScreenUI();
    }
  }
}
