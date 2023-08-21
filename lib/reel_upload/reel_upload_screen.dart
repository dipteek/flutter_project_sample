import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:reel_app/convert.dart';
import 'package:reel_app/loading_screen/loading_screen.dart';
import 'package:reel_app/model_classes/reel_model.dart';
import 'package:reel_app/model_classes/user_model.dart';
import 'package:reel_app/reel_upload/reel_upload_function.dart';
import 'package:video_player/video_player.dart';

class ReelUploadScreen extends StatefulWidget {
  UserModel userModel;
  ReelUploadScreen({super.key, required this.userModel});

  @override
  State<ReelUploadScreen> createState() => _ReelUploadScreenState();
}

class _ReelUploadScreenState extends State<ReelUploadScreen> {
  File? videoFile; // File.io
  VideoPlayerController? controller;
  TextEditingController title = TextEditingController();
  bool isLoading = false;

  void onReelPost() async {
    if (widget.userModel.username != "") {
      if (videoFile != null && title.text.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        String videoId = generatedId();
        String videoUrl =
            await ReelUploadFunction.uploadVideo(videoFile!, videoId) ?? "";

        if (videoUrl.isNotEmpty) {
          ReelModel reelModel = ReelModel(
            uid: widget.userModel.uid,
            id: videoId,
            username: widget.userModel.username!,
            profileImage: widget.userModel.profileImage!,
            title: title.text,
            videoLink: videoUrl,
            likes: 0,
          );

          await ReelUploadFunction.postReel(reelModel);
        } else {
          toast("Choose other video");
        }
      } else {
        toast("All Field Are Required",
            bgColor: Colors.red, textColor: Colors.white);
      }
    } else {
      toast("Please fill username From Profile Page");
    }

    setState(() {
      isLoading = false;
    });
  }

  void pickVideoFile() async {
    final filePickerResult =
        await FilePicker.platform.pickFiles(type: FileType.video);

    if (filePickerResult != null) {
      setState(() {
        videoFile = File(filePickerResult.paths[0]!);

        controller = VideoPlayerController.file(videoFile!);
        controller!.initialize();
        toast("To Playing Video Double Click on Video");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Upload Reel"),
        ),
        body: isLoading
            ? LoadingScreen()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: pickVideoFile,
                      onDoubleTap: () {
                        if (controller != null) {
                          if (controller!.value.isPlaying) {
                            controller!.pause();
                          } else {
                            controller!.play();
                          }
                        } else {
                          toast("Please Choose Reel Video");
                        }
                      },
                      child: Container(
                        child: controller == null
                            ? SizedBox()
                            : VideoPlayer(controller!),
                        width: 300,
                        height: 500,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: title,
                        decoration: InputDecoration(
                          hintText: "Some Words On Reels",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: onReelPost, child: Text("Upload Reel"))
                  ],
                ),
              ));
  }
}
