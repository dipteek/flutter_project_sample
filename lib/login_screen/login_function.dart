import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reel_app/Auth/Auth.dart';
import 'package:reel_app/login_screen/login_screen_ui.dart';
import 'package:reel_app/model_classes/user_model.dart';
import 'package:reel_app/shared_prefrences/shared_prefrences.dart';

class LoginFunction {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> login(String email, String passW) async {
    try {
      final result =
          await _auth.signInWithEmailAndPassword(email: email, password: passW);
      if (result.user != null) {
        await getUserData();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut().then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Auth(),
          ),
          (route) => false);
    });
  }

  static Future<void> getUserData() async {
    try {
      final result = await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .get();

      UserModel userModel = UserModel.fromJson(result.data()!);

      await SharedPreferencesHelper.saveString("uid", userModel.uid);
      await SharedPreferencesHelper.saveString("username", userModel.username!);
      await SharedPreferencesHelper.saveString(
          "profile_image", userModel.profileImage!);
    } catch (e) {}
  }
}
