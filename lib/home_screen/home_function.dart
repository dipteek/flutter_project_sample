import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:reel_app/model_classes/reel_model.dart';

class HomeFunction {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<List<ReelModel>?> getReels() async {
    try {
      final result = await _firebaseFirestore.collection("reels").get();

      List<ReelModel> reelModel = [];
      reelModel = result.docs.map((e) => ReelModel.fromJson(e.data())).toList();

      return reelModel;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<void> onLikeOrUnLike(String reelId, bool isLike) async {
    try {
      final reelReference =
          await _firebaseFirestore.collection("reels").doc(reelId);

      final likeDataReference = await _firebaseFirestore
          .collection("reels")
          .doc(reelId)
          .collection("likes")
          .doc(_auth.currentUser!.uid);

      await _firebaseFirestore.runTransaction(
        (transaction) async {
          final reel = await transaction.get(reelReference);

          int likesCount = reel.data()!['likes'];

          if (isLike) {
            transaction.update(reelReference, {"likes": likesCount + 1});

            transaction.set(likeDataReference, {"uid": _auth.currentUser!.uid});
          } else {
            transaction.update(reelReference, {"likes": likesCount - 1});

            transaction.delete(likeDataReference);
          }
        },
      );
    } catch (e) {
      toast("Currently Our Server Down");
    }
  }

  static Future<bool> isAlreadyLiked(String reelId) async {
    try {
      final result = await _firebaseFirestore
          .collection("reels")
          .doc(reelId)
          .collection("likes")
          .doc(_auth.currentUser!.uid)
          .get();

      return result.exists;
    } catch (e) {
      return false;
    }
  }
}
