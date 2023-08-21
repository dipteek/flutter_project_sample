import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:reel_app/comment_screen/comment_screen.dart';
import 'package:reel_app/convert.dart';
import 'package:reel_app/home_screen/home_function.dart';
import 'package:reel_app/model_classes/reel_model.dart';
import 'package:reel_app/profile_screen/profile_screen_ui_up.dart';
import 'package:video_player/video_player.dart';

class ReelScreenView extends StatefulWidget {
  final ReelModel reelsModel;
  ReelScreenView({super.key, required this.reelsModel});

  @override
  State<ReelScreenView> createState() => _ReelScreenViewState();
}

class _ReelScreenViewState extends State<ReelScreenView> {
  late VideoPlayerController videoController;
  bool isLoading = true;

  bool isBackPlay = false;

  bool isAlreadyLike = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfAlready();
    setState(() {});
    initializeVideo();
    setState(() {});
  }

  void initializeVideo() {
    videoController =
        VideoPlayerController.network(widget.reelsModel.videoLink);
    videoController.initialize().then(
      (value) {
        setState(() {
          isLoading = false;
        });

        videoController.play();
      },
    );

    setState(() {});
  }

  Future<void> checkIfAlready() async {
    isAlreadyLike = await HomeFunction.isAlreadyLiked(widget.reelsModel.id);
  }

  @override
  void dispose() {
    videoController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (videoController.value.isPlaying) {
        //isBackPlay = false;
      } else {
        //isBackPlay = true;
      }

      if (isBackPlay == false) {
        videoController.play();
      }
    });
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      color: Colors.grey[500],
      child: Stack(
        children: [
          InkWell(
            onDoubleTap: () {
              if (videoController != null) {
                if (videoController!.value.isPlaying) {
                  videoController!.pause();
                  isBackPlay = true;
                } else {
                  videoController!.play();
                  isBackPlay = false;
                }
                setState(() {});
              }
            },
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              color: Colors.grey[500],
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : VideoPlayer(videoController),
            ),
          ),
          isBackPlay
              ? Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  child: Center(
                      child: IconButton(
                    onPressed: () {
                      setState(() {
                        isBackPlay = false;
                      });
                    },
                    icon: Icon(
                      Icons.play_circle_outlined,
                      color: Colors.white,
                      size: 60.sp,
                    ),
                  )),
                )
              : SizedBox(),
          Positioned(
            bottom: 0,
            child: Container(
              height: 186.h,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: AlignmentDirectional.bottomEnd,
                    colors: [Color.fromARGB(71, 0, 0, 0), Colors.transparent]),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 130, left: 10, right: 55),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                videoController.pause();
                                setState(() {
                                  isBackPlay = true;
                                });

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreenUiUp(
                                          UserId: widget.reelsModel.uid),
                                    ));
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.blueGrey,
                                backgroundImage: widget
                                        .reelsModel.profileImage.isNotEmpty
                                    ? NetworkImage(
                                        widget.reelsModel.profileImage)
                                    : NetworkImage(
                                        "https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                widget.reelsModel.username,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 3),
                              child: Text(
                                widget.reelsModel.title,
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 55.h,
              right: 1.w,
              child: Container(
                width: 55.w,
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (isAlreadyLike) {
                          setState(() {
                            widget.reelsModel.likes =
                                widget.reelsModel.likes - 1;
                            isAlreadyLike = false;
                          });
                          HomeFunction.onLikeOrUnLike(
                              widget.reelsModel.id, false);
                        } else {
                          setState(() {
                            widget.reelsModel.likes =
                                widget.reelsModel.likes + 1;
                            isAlreadyLike = true;
                          });
                          HomeFunction.onLikeOrUnLike(
                              widget.reelsModel.id, true);
                        }
                        //videoController.dispose();
                        //videoController.pause();
                      },
                      icon: Icon(
                        Icons.heart_broken_rounded,
                        color: isAlreadyLike ? primaryColor : Colors.white,
                        size: 30.sp,
                      ),
                    ),
                    Text(
                      widget.reelsModel.likes.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    IconButton(
                      onPressed: () {
                        videoController.pause();
                        setState(() {
                          isBackPlay = true;
                        });

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CommentScreenUI(reelId: widget.reelsModel.id),
                            ));
                      },
                      icon: Icon(
                        Icons.comment_rounded,
                        color: Colors.white,
                        size: 30.sp,
                      ),
                    ),
                  ],
                ),
              )),
          /*Positioned(
              bottom: 95.h,
              right: 0,
              child: Container(
                width: 55,
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.heart_broken_rounded,
                        color: Colors.white,
                        size: 30.sp,
                      ),
                    ),
                  ],
                ),
              )),
          Positioned(
              bottom: 92.h,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                width: 55,
                child: Text(
                  "1.2k",
                  style: TextStyle(color: Colors.white),
                ),
              )),
          Positioned(
              bottom: 45.h,
              right: 0,
              child: Container(
                width: 55,
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.comment_rounded,
                        color: Colors.white,
                        size: 30.sp,
                      ),
                    ),
                  ],
                ),
              )),*/
          Positioned(
              right: 5,
              top: 15,
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreenUiUp(
                              UserId: FirebaseAuth.instance.currentUser!.uid),
                        ));
                  },
                  icon: const Icon(Icons.account_box_rounded,
                      color: Colors.white, size: 30)))
        ],
      ),
    );
  }
}
