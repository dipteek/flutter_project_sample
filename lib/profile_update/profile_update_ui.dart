import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:reel_app/loading_screen/loading_screen.dart';
import 'package:reel_app/model_classes/user_model.dart';
import 'package:reel_app/profile_screen/profile_function.dart';
import 'package:reel_app/profile_update/profile_update_function.dart';

import '../convert.dart';

class ProfileUpdateUI extends StatefulWidget {
  UserModel userModel;
  ProfileUpdateUI({super.key, required this.userModel});

  @override
  State<ProfileUpdateUI> createState() => _ProfileUpdateUIState();
}

class _ProfileUpdateUIState extends State<ProfileUpdateUI> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController addLinkController = TextEditingController();
  File? profileImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setUserDetails();
  }

  void pickImage() async {
    final pickedImage = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      profileImage = File(pickedImage.path);
      setState(() {});
    }
  }

  void onSavingDetails() async {
    setState(() {
      isLoading = true;
    });
    if (nameController.text.isNotEmpty &&
        userNameController.text.isNotEmpty &&
        bioController.text.isNotEmpty) {
      String profileImageUrl = "";
      if (profileImage != null) {
        String imageId = generatedId();
        profileImageUrl =
            await ProfileUpdateFunction.uploadImage(profileImage!, imageId) ??
                "";
      }

      Map<String, dynamic> userDetails = {
        "name": nameController.text,
        "username": userNameController.text,
        "bio": bioController.text,
        "add_link": addLinkController.text,
        "profile_image": profileImageUrl.isNotEmpty
            ? profileImageUrl
            : widget.userModel.profileImage,
      };

      bool isSucess =
          await ProfileUpdateFunction.updateUserProfile(userDetails);
      if (isSucess) {
        // ignore: use_build_context_synchronously
        snackBar(
          context,
          title: "Successfully updated",
          duration: 2.seconds,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: radius(30)),
          margin: const EdgeInsets.all(5),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        // ignore: use_build_context_synchronously
        snackBar(
          context,
          title: "Something Wrong",
          duration: 3.seconds,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: radius(30)),
          margin: const EdgeInsets.all(10),
        );
      }
    } else {
      print("username and name required");
      toast("username and name required");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Edit Profile"),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close)),
              actions: [
                IconButton(
                    onPressed: onSavingDetails,
                    icon: const Icon(Icons.done_rounded))
              ],
            ),
            body: SizedBox(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        height: 90.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: profileImage != null
                                    ? FileImage(profileImage!) as ImageProvider
                                    : NetworkImage(
                                        widget.userModel.profileImage!))),
                        /*child: Icon(Icons.account_circle_rounded, size: 90.sp),*/
                      ),
                    ),
                    TextButton(
                      onPressed: pickImage,
                      child: Text("Change Profile Image",
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueAccent)),
                    ),
                    customTextField("Name", nameController),
                    customTextField("Username", userNameController),
                    customTextField("Profession", bioController),
                    customTextField("Add link", addLinkController),
                  ],
                ),
              ),
            ),
          );
  }

  void setUserDetails() {
    nameController.text = widget.userModel.name!;
    userNameController.text = widget.userModel.username!;
    bioController.text = widget.userModel.bio!;
    addLinkController.text = widget.userModel.addLink!;
  }

  Widget customTextField(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hintText),
      ),
    );
  }
}
