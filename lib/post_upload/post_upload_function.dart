import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:reel_app/model_classes/post_model.dart';
import 'package:reel_app/model_classes/reel_model.dart';
import 'package:reel_app/model_classes/user_model.dart';

class PostUploadFunction {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> newPost(PostModel postModel) async {
    try {
      await _firestore
          .collection("posts")
          .doc(postModel.id)
          .set(postModel.toJson());

      toast("Post Has been Uploaded");
      print("uploaded image");
    } catch (e) {
      print(e);
    }
  }

  static Future<String?> uploadImage(File imageFile, String imageName) async {
    try {
      final reference =
          _firebaseStorage.ref().child("images/posts/$imageName.png");

      final uploadTask = reference.putFile(imageFile);

      await uploadTask.whenComplete(() {});
      String downloadUrl = await reference.getDownloadURL();
      return downloadUrl;
    } catch (e) {}
  }

  static Future<List<PostModel>?> getPosts() async {
    try {
      final result = await _firestore.collection("posts").get();

      List<PostModel> postsModel = [];
      postsModel =
          result.docs.map((e) => PostModel.fromJson(e.data())).toList();

      return postsModel;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String> getPostedUserProfileImg(String userId) async {
    try {
      final result = await _firestore.collection("users").doc(userId).get();

      UserModel userModel = UserModel.fromJson(result.data()!);

      String profileImg = await userModel.profileImage!;

      return profileImg;
    } catch (e) {
      return "";
    }
  }
}
