import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reel_app/following_screen/following_follow_function.dart';
import 'package:reel_app/loading_screen/loading_screen.dart';
import 'package:reel_app/model_classes/user_model.dart';
import 'package:reel_app/profile_screen/profile_screen_ui_up.dart';

class FollowingFollowScreen extends StatefulWidget {
  final String screenType;
  final String UserUid;
  FollowingFollowScreen(
      {super.key, required this.screenType, required this.UserUid});

  @override
  State<FollowingFollowScreen> createState() => _FollowingFollowScreenState();
}

class _FollowingFollowScreenState extends State<FollowingFollowScreen> {
  List<UserModel> userModel = [];

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFollowerAndFollowing();
  }

  void getFollowerAndFollowing() async {
    userModel = await FollowingFollowFunction.getFollowingFollowersData(
            widget.UserUid, widget.screenType.toLowerCase()) ??
        [];

    setState(() {
      isLoading = false;
    });

    print("Our data");
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
                title: widget.screenType == "Followers"
                    ? Text("Followers")
                    : Text("Following")),
            body: ListView.builder(
              itemCount: userModel.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    print(userModel[index].toJson());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreenUiUp(UserId: userModel[index].uid),
                        ));
                  },
                  title: Text(userModel[index].name!),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    backgroundImage:
                        NetworkImage(userModel[index].profileImage!),
                  ),
                );
              },
            ),
          );
  }
}
