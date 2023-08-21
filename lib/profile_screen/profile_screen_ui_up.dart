import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:reel_app/convert.dart';
import 'package:reel_app/following_screen/following_follow_function.dart';
import 'package:reel_app/following_screen/following_follow_screen.dart';
import 'package:reel_app/loading_screen/loading_screen.dart';
import 'package:reel_app/login_screen/login_function.dart';
import 'package:reel_app/model_classes/reel_model.dart';
import 'package:reel_app/model_classes/user_model.dart';
import 'package:reel_app/profile_screen/profile_function.dart';
import 'package:reel_app/reel_upload/reel_upload_screen.dart';
import 'package:reel_app/search_screen/search_screen_ui.dart';
import 'package:video_player/video_player.dart';

import '../profile_update/profile_update_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreenUiUp extends StatefulWidget {
  final String UserId;
  ProfileScreenUiUp({super.key, required this.UserId});

  @override
  State<ProfileScreenUiUp> createState() => _ProfileScreenUiUpState();
}

class _ProfileScreenUiUpState extends State<ProfileScreenUiUp> {
  Color desColor = const Color.fromARGB(255, 173, 174, 174);
  UserModel? model;
  bool isFollow = false;
  String follow = "Follow";

  bool isLoading = true;

  List<ReelModel> reelModel = [];

  bool get isCurrentUser =>
      FirebaseAuth.instance.currentUser!.uid == widget.UserId;
  // c683e5
  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
    followYesUnFollow();
    setState(() {});
  }

  void getCurrentUserDetails() async {
    model = await ProfileFunction.getUserProfileDetails(widget.UserId);
    reelModel = await ProfileFunction.getUserReels(widget.UserId) ?? [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return model == null
        ? const LoadingScreen()
        : Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Text(
                        "User Profile",
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w400),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReelUploadScreen(userModel: model!),
                                ));
                          },
                          icon: const Icon(Icons.add)),
                      IconButton(
                          onPressed: () {
                            LoginFunction().logout(context);
                          },
                          icon: const Icon(Icons.logout_rounded)),
                      IconButton(
                          onPressed: () {
                            showSearch(
                                context: context, delegate: SearchScreenUI());
                          },
                          icon: const Icon(Icons.search)),
                      //more_horiz_rounded
                    ],
                  ),
                ),
                Container(
                  height: 90.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                    color: primaryColor /*Colors.blueGrey[400]*/,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(model!.profileImage ?? ""),
                        fit: BoxFit.fill),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(model!.name ?? "",
                    style: TextStyle(
                        fontSize: 15.sp, fontWeight: FontWeight.w500)),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: "@",
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: desColor),
                  ),
                  TextSpan(
                    text: model!.username,
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: desColor),
                  )
                ])),
                Text("",
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: desColor)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      showDetails("Posts", model!.posts.toString(), "Post"),
                      showDetails("Followers", model!.followers.toString(),
                          "Followers"),
                      showDetails("Following", model!.following.toString(),
                          "Following"),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                isCurrentUser
                    ? customButton(isCurrentUser
                        /*widget.UserId != FirebaseAuth.instance.currentUser!.uid
                        ? false
                        : true*/
                        )
                    : isLoading
                        ? CircularProgressIndicator()
                        : customButton(isCurrentUser
                            /*widget.UserId != FirebaseAuth.instance.currentUser!.uid
                        ? false
                        : true*/
                            ),
                SizedBox(height: 10.h),
                InkWell(
                  onTap: () async {
                    Uri uri = Uri.parse(model!.addLink!);
                    if (await canLaunchUrl(uri)) {
                      toast('Url Launched');
                      launchUrl(uri);
                    } else {
                      toast('Url Cannot Launch');
                      launchUrl(uri);
                      print("Url cannot launch");
                    }
                  },
                  child: Text(model!.addLink ?? "",
                      style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue)),
                ),
                Expanded(
                    child: GridView.builder(
                  itemCount: reelModel.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return VideoThumbnail(
                      reelsModel: reelModel[index],
                    );
                  },
                ))
              ],
            ),
          );
  }

  Widget showDetails(
      String txtContain, String numericContain, String screenType) {
    return InkWell(
      onTap: () {
        if (screenType == "Followers" || screenType == "Following") {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FollowingFollowScreen(
                    screenType: screenType, UserUid: model!.uid),
              ));
        } else {
          /*List<UserModel> Ulist = [];
          Ulist = FollowingFollowFunction.followOrUnFollow(widget.UserId)
              as List<UserModel>;*/
        }
      },
      child: Column(
        children: [
          Text(numericContain,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
          Text(txtContain,
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500))
        ],
      ),
    );
  }

  Widget chipButton(bool isCurrentUserProfile) {
    return Chip(
      backgroundColor: primaryColor,
      label: Text(isCurrentUserProfile ? "Edit Profile" : "Follow",
          style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white)),
      avatar: Icon(
          isCurrentUserProfile
              ? Icons.edit_rounded
              : Icons.person_add_alt_1_outlined,
          color: Colors.white),
    );
  }

  Widget customButton(bool isCurrentUserProfile) {
    if (isFollow) {
      follow = "UnFollow";
    } else {
      follow = "Follow";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: () {
          if (isCurrentUserProfile) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileUpdateUI(userModel: model!),
                ));
          } else {
            // Follow Functionality
            if (isFollow) {
              setState(() {
                model!.followers = model!.followers! - 1;
                ProfileFunction.onFollowAndUnFollow(false, widget.UserId);
                isFollow = false;
              });
            } else {
              setState(() {
                model!.followers = model!.followers! + 1;

                isFollow = true;
              });
              ProfileFunction.onFollowAndUnFollow(true, widget.UserId);
            }
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: primaryColor),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(isCurrentUserProfile ? "Edit Profile" : follow,
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
          ),
        ),
      ),
    );
  }

  void followYesUnFollow() async {
    //isFollow = await FollowingFollowFunction.followOrUnFollow(widget.UserId);
    isFollow = await FollowingFollowFunction.chechIsFollow(widget.UserId);
    isLoading = false;
    setState(() {});
  }
}

class VideoThumbnail extends StatefulWidget {
  ReelModel reelsModel;
  VideoThumbnail({super.key, required this.reelsModel});

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  late VideoPlayerController videoPlayerController;
  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.network(widget.reelsModel.videoLink);
    videoPlayerController.initialize();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(videoPlayerController);
  }
}
