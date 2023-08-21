import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reel_app/model_classes/user_model.dart';
import 'package:reel_app/search_screen/search_function.dart';

import '../profile_screen/profile_screen_ui_up.dart';

class SearchScreenUI extends SearchDelegate {
  List<UserModel> userModel = [];

  void searchUser() async {
    userModel = await SearchFunction.searchUsers(query) ?? [];
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
            userModel = [];
          },
          icon: const Icon(Icons.close)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return const BackButton();
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: userModel.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(userModel[index].username!),
          leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(userModel[index].profileImage!)),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searchUser();
    return ListView.builder(
      itemCount: userModel.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreenUiUp(
                    UserId: userModel[index].uid,
                  ),
                ));
          },
          title: Text(userModel[index].username!),
          leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(userModel[index].profileImage!)),
        );
      },
    );
  }
}
