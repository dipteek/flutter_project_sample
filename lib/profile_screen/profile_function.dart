import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reel_app/model_classes/reel_model.dart';
import 'package:reel_app/model_classes/user_model.dart';

class ProfileFunction {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  static Future<UserModel?> getUserProfileDetails(String UserId) async {
    final result = await _firebaseFirestore
        .collection("users")
        .doc(UserId) //_auth.currentUser!.uid
        .get();

    UserModel userModel = UserModel.fromJson(result.data()!);

    return userModel;
  }

  static Future<void> onFollowAndUnFollow(
      bool isFollow, String profileUserId) async {
    try {
      final currentUserProfileReference =
          _firebaseFirestore.collection("users").doc(_auth.currentUser!.uid);

      final profileUserProfileReference =
          _firebaseFirestore.collection("users").doc(profileUserId);

      final currentUserFollowerReference = _firebaseFirestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("following")
          .doc(profileUserId);

      final profileUserFollowerReference = _firebaseFirestore
          .collection("users")
          .doc(profileUserId)
          .collection("followers")
          .doc(_auth.currentUser!.uid);

      await currentUserFollowerReference.set({"uid": profileUserId});
      await profileUserFollowerReference.set({"uid": _auth.currentUser!.uid});

      await _firebaseFirestore.runTransaction(
        (transaction) async {
          final profileUser =
              await transaction.get(profileUserProfileReference);

          final currentUser =
              await transaction.get(currentUserProfileReference);

          int profileUserFollowerCount = profileUser['followers'];
          int currentUserFollowingCount = currentUser['following'];

          print(currentUserFollowingCount);
          print(profileUserFollowerCount);

          if (isFollow) {
            transaction.update(profileUserProfileReference, {
              "followers": profileUserFollowerCount + 1,
            });

            transaction.update(currentUserProfileReference, {
              "following": currentUserFollowingCount + 1,
            });

            transaction.set(
              currentUserFollowerReference,
              {"uid": profileUserId},
            );

            transaction.set(
                profileUserFollowerReference, {"uid": _auth.currentUser!.uid});
          } else {
            transaction.update(profileUserProfileReference, {
              "followers": profileUserFollowerCount - 1,
            });

            transaction.update(currentUserProfileReference, {
              "following": currentUserFollowingCount - 1,
            });

            transaction.delete(currentUserFollowerReference);

            transaction.delete(profileUserFollowerReference);
          }
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<List<ReelModel>?> getUserReels(String userId) async {
    try {
      final result = await _firebaseFirestore
          .collection("reels")
          .where("uid", isEqualTo: userId)
          .get();
      List<ReelModel> reelModel = [];

      reelModel = result.docs.map((e) => ReelModel.fromJson(e.data())).toList();
      print(reelModel[0].username);
      return reelModel;
    } catch (e) {
      return null;
    }
  }
}
