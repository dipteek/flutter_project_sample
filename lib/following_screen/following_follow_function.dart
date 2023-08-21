import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reel_app/model_classes/user_model.dart';

class FollowingFollowFunction {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<UserModel>?> getFollowingFollowersData(
      String userUid, String collection) async {
    try {
      final result = await _firestore
          .collection("users")
          .doc(userUid)
          .collection(collection)
          .get();

      //print(result.docs.map((e) => UserModel.fromJson(e.data())).toList());

      List<UserModel> userModel = [];

      for (var element in result.docs) {
        final user = await _firestore
            .collection("users")
            .doc(element.data()['uid'])
            .get();

        if (user.exists) {
          userModel.add(UserModel.fromJson(user.data()!));
        } else {
          print(" Not found  ");
        }
      }

      //userModel = result.docs.map((e) => UserModel.fromJson(e.data())).toList();

      return userModel;
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> followOrUnFollow(String userId) async {
    dynamic following_uid;
    final result = await _firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("following")
        .get();

    //print(result.docs.map((e) => UserModel.fromJson(e.data())).toList());

    List<UserModel> userModel = [];

    for (var element in result.docs) {
      final user =
          await _firestore.collection("users").doc(element.data()['uid']).get();

      if (user.exists) {
        userModel.add(UserModel.fromJson(user.data()!));

        following_uid = (user.data()! as dynamic)['uid'];
        print(user.data());
        print(userId);
      } else {
        print(" Not found  ");
      }
    }

    if (following_uid.contains(userId)) {
      print("true");
      return true;
    } else {
      print("false");
      return false;
    }

    /*final userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("following")
        .where(userId)
        .get();*/

    /*final snap = await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final following = (snap.data()! as dynamic)['following'];

    //following.contains(followId)

    if (following.contains(userId)) {
      return true;
    } else {
      return false;
    }
    print("object");
    print(following.toString());
    return false;*/

    /*DocumentSnapshot snap =
        await _firestore.collection('users').doc(userId).get();
    //List following = (snap.data()! as dynamic)['following'];

    print("following");

    List<UserModel> userModel = [];
    userModel = userSnap.docs.map((e) => UserModel.fromJson(e.data())).toList();

    //print(userSnap.docs.);
    // print(userSnap.docs.map((e) => UserModel.fromJson(e.data())).toList());
    //UserModel userModel = UserModel.fromJson(userSnap.data()!);*/
    //return userModel;
  }

  static Future<bool> chechIsFollow(String userId) async {
    try {
      final userSnap = await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("following")
          .doc(userId)
          .get();

      return userSnap.exists;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
