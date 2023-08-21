import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:reel_app/convert.dart';
import 'package:reel_app/loading_screen/loading_screen.dart';
import 'package:reel_app/model_classes/post_model.dart';
import 'package:reel_app/post_upload/post_upload_function.dart';
import 'package:reel_app/shared_prefrences/shared_prefrences.dart';

class PostUploadScreen extends StatefulWidget {
  const PostUploadScreen({super.key});

  @override
  State<PostUploadScreen> createState() => _PostUploadScreenState();
}

class _PostUploadScreenState extends State<PostUploadScreen> {
  TextEditingController descController = TextEditingController();
  File? postImg;
  bool uploadAllow = false;
  String imgUrl = "";
  bool isLoading = false;

  void onPostStories() async {
    String uid = await SharedPreferencesHelper.getString("uid");
    String username = await SharedPreferencesHelper.getString("username");
    String profileImage =
        await SharedPreferencesHelper.getString("profile_image");
    if ((postImg != null || descController.text.isNotEmpty) &&
        profileImage.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      if (postImg != null) {
        String imageId = generatedId();
        imgUrl = await PostUploadFunction.uploadImage(postImg!, imageId) ?? "";
      }

      String postId = generatedId();
      if (postImg != null || descController.text.isNotEmpty) {
        PostModel postModel = PostModel(
            uid: uid,
            id: postId,
            username: username,
            description: descController.text,
            date: DateTime.now().toString(),
            imgLink: imgUrl,
            likes: 0);

        await PostUploadFunction.newPost(postModel);
      } else {
        toast("Required both of one from Image and Description");
      }
    } else {
      toast("All Field Are Required",
          bgColor: Colors.red, textColor: Colors.white);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: Text("Upload Post"),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: pickImage,
                    child: Container(
                      child: Text("Upload Post Image"),
                      height: 300,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: descController,
                      decoration: InputDecoration(
                        hintText: "Description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: onPostStories, child: Text("Upload Post"))
                ],
              ),
            ));
  }

  void pickImage() async {
    final pickedImage = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      postImg = File(pickedImage.path);
      uploadAllow = true;
      setState(() {});
    }
  }
}
