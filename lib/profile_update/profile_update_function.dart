import 'dart:ffi';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reel_app/model_classes/reel_model.dart';

class ProfileUpdateFunction {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static FirebaseStorage _fireBaseStorage = FirebaseStorage.instance;
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<bool> updateUserProfile(
      Map<String, dynamic> userDetails) async {
    try {
      _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update(userDetails);

      print("Details Updated ");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<String?> uploadImage(File imageFile, String imageName) async {
    try {
      final reference = _fireBaseStorage.ref().child("images/$imageName.png");

      final uploadTask = reference.putFile(imageFile);

      await uploadTask.whenComplete(() {});
      String downloadUrl = await reference.getDownloadURL();
      return downloadUrl;
    } catch (e) {}
  }
}
