import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:reel_app/convert.dart';
import 'package:reel_app/model_classes/stories_model.dart';
import 'package:reel_app/shared_prefrences/shared_prefrences.dart';
import 'package:reel_app/stories_screen/stories_upload_function.dart';

class StoriesUploadScreen extends StatefulWidget {
  StoriesUploadScreen({super.key});

  @override
  State<StoriesUploadScreen> createState() => _StoriesUploadScreenState();
}

class _StoriesUploadScreenState extends State<StoriesUploadScreen> {
  File? storiesImage;
  String? dropDownSelectedValue = 'Text';
  bool uploadAllow = false;
  String? imgUrl;
  bool isLoading = false;

  void onReelStories() async {
    if (storiesImage != null && uploadAllow) {
      String uid = await SharedPreferencesHelper.getString("uid");
      String username = await SharedPreferencesHelper.getString("username");
      String profileImage =
          await SharedPreferencesHelper.getString("profile_image");
      setState(() {
        isLoading = true;
      });

      if (storiesImage != null) {
        String imageId = generatedId();
        imgUrl =
            await StoriesUploadFunction.uploadImage(storiesImage!, imageId) ??
                "";
      }

      String storyId = generatedId();
      if (uploadAllow && profileImage.isNotEmpty) {
        StoriesModel storiesModel = StoriesModel(
          uid: uid,
          id: storyId,
          username: username,
          profileImage: profileImage,
          image: imgUrl!,
          text: "",
          type: dropDownSelectedValue!,
          date: DateTime.now().toString(),
        );

        await StoriesUploadFunction.postStories(storiesModel);
      } else {
        toast("Choose other image and Upload Profile Image");
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Story"),
        elevation: 1,
      ),
      body: SizedBox(
        child: Column(
          children: [
            Center(
              child: Text("Choose Story Type"),
            ),
            DropdownButton(
              value: dropDownSelectedValue,
              items: ['Text', 'Image', 'hh']
                  .map((String itemValue) => DropdownMenuItem(
                      value: itemValue, child: Text(itemValue)))
                  .toList(),
              onChanged: (selectedData) {
                setState(() {
                  dropDownSelectedValue = selectedData;
                  print(dropDownSelectedValue);
                });
              },
            ),
            uploadUi()
          ],
        ),
      ),
    );
  }

  Widget uploadUi() {
    return Container(
      child: Column(
        children: [
          ElevatedButton(onPressed: pickImage, child: Text("Choose Image")),
          ElevatedButton(
              onPressed: onReelStories, child: Text("Upload Stories")),
        ],
      ),
    );
  }

  void pickImage() async {
    final pickedImage = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      storiesImage = File(pickedImage.path);
      uploadAllow = true;
      setState(() {});
    }
  }
}
