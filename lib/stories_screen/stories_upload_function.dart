import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:reel_app/model_classes/stories_model.dart';

class StoriesUploadFunction {
  static FirebaseStorage _fireBaseStorage = FirebaseStorage.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<String?> uploadImage(File imageFile, String imageName) async {
    try {
      final reference =
          _fireBaseStorage.ref().child("images/stories/$imageName.png");

      final uploadTask = reference.putFile(imageFile);

      await uploadTask.whenComplete(() {});
      String downloadUrl = await reference.getDownloadURL();
      return downloadUrl;
    } catch (e) {}
  }

  static Future<void> postStories(StoriesModel storiesModel) async {
    try {
      await _firestore
          .collection("stories")
          .doc(storiesModel.id)
          .set(storiesModel.toJson());

      toast("Story Has been Uploaded");
      print("uploaded video");
    } catch (e) {
      print(e);
    }
  }

  static Future<List<StoriesModel>?> getStories() async {
    try {
      final result = await _firestore.collection("stories").get();

      List<StoriesModel> storiesModel = [];
      storiesModel =
          result.docs.map((e) => StoriesModel.fromJson(e.data())).toList();

      return storiesModel;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
