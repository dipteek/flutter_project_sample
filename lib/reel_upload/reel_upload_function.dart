import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:reel_app/model_classes/reel_model.dart';

class ReelUploadFunction {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> postReel(ReelModel reelModel) async {
    try {
      await _firestore
          .collection("reels")
          .doc(reelModel.id)
          .set(reelModel.toJson());

      toast("Reels Has been Uploaded");
      print("uploaded video");
    } catch (e) {
      print(e);
    }
  }

  static Future<String?> uploadVideo(File videoFile, String videoName) async {
    toast("Video Uploading");
    try {
      final reference = _firebaseStorage.ref().child("reels/$videoName.png");

      final uploadTask = reference.putFile(videoFile);

      await uploadTask.whenComplete(() {});
      String downloadUrl = await reference.getDownloadURL();
      toast("Video Uploaded");
      return downloadUrl;
    } catch (e) {
      toast("Video Upload Failed",
          bgColor: Colors.red, textColor: Colors.white);
    }
  }
}
