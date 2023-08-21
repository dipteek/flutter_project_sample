import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reel_app/model_classes/user_model.dart';

class SignupFunction {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  static Future<bool> createAccount(String email, String pass) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      if (result.user != null) {
        _saveUserDetails(email);
        //print("Account Created Successfully");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> _saveUserDetails(String email) async {
    try {
      String uid = _auth.currentUser!.uid;

      UserModel userModel = UserModel(
        uid: uid,
        name: "",
        email: email,
        username: "",
        bio: "",
        addLink: "",
        profileImage: "",
        posts: 0,
        followers: 0,
        following: 0,
      );

      _firebaseFirestore.collection('users').doc(uid).set(userModel.toJson());

      print("Details Saved Successfully");
    } catch (e) {
      print(e);
    }
  }
}
