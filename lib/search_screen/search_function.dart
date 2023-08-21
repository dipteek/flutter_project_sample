import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reel_app/model_classes/user_model.dart';

class SearchFunction {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<UserModel>?> searchUsers(String query) async {
    try {
      final result = await _firestore
          .collection("users")
          .where("username", isGreaterThanOrEqualTo: query)
          .get();

      List<UserModel> userModel = [];
      userModel = result.docs.map((e) => UserModel.fromJson(e.data())).toList();

      return userModel;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
