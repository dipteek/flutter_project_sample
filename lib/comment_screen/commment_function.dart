import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reel_app/model_classes/comment_model.dart';
import 'package:reel_app/model_classes/reel_model.dart';

class CommentFunction {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> postComment(
      String reelId, CommentsModel commentsModel) async {
    try {
      final result = await _firestore
          .collection("reels")
          .doc(reelId)
          .collection("comments")
          .doc(commentsModel.id)
          .set(commentsModel.toJson());
    } catch (e) {}
  }

  static Future<List<CommentsModel>?> getAllReelComment(String reelId) async {
    try {
      final result = await _firestore
          .collection("reels")
          .doc(reelId)
          .collection("comments")
          .get();

      List<CommentsModel> commentModel = [];

      commentModel = await result.docs
          .map((e) => CommentsModel.fromJson(e.data()))
          .toList();

      return commentModel;
    } catch (e) {
      return null;
    }
  }
}
