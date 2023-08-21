import 'package:flutter/material.dart';
import 'package:reel_app/convert.dart';
import 'package:reel_app/custom_home.dart';
import 'package:reel_app/home_screen/home_function.dart';
import 'package:reel_app/home_screen/reel_screen_view.dart';
import 'package:reel_app/loading_screen/loading_screen.dart';
import 'package:reel_app/login_screen/login_function.dart';
import 'package:reel_app/login_screen/login_screen_ui.dart';
import 'package:reel_app/model_classes/reel_model.dart';
import 'package:reel_app/model_classes/stories_model.dart';
import 'package:reel_app/post_upload/post_screen_ui.dart';
import 'package:reel_app/post_upload/post_upload_screen.dart';
import 'package:reel_app/profile_screen/profile_screen_ui.dart';
import 'package:reel_app/profile_screen/profile_screen_ui_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reel_app/stories_screen/stories_screen.dart';
import 'package:reel_app/stories_screen/stories_upload_function.dart';

import '../stories_screen/stories_upload_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ReelModel> reelModel = [];
  List<StoriesModel> storiesModel = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getReelData();
    getStroyData();
  }

  void getReelData() async {
    reelModel = await HomeFunction.getReels() ?? [];

    setState(() {
      isLoading = false;
    });
  }

  void getStroyData() async {
    storiesModel = await StoriesUploadFunction.getStories() ?? [];

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreenUiUp(
                          UserId: FirebaseAuth.instance.currentUser!.uid),
                    ));
              },
              icon: const Icon(Icons.account_box_rounded)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostUploadScreen(),
                    ));
              },
              icon: const Icon(Icons.post_add_rounded))
        ],
      ),
      body: isLoading
          ? LoadingScreen()
          : Column(
              children: [
                SizedBox(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoriesUploadScreen(),
                                ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: lightBg,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(blurRadius: 5.0, color: lightBg)
                                ]),
                            width: 50,
                            height: 50,
                            child: CircleAvatar(
                              child: Container(
                                  decoration: BoxDecoration(
                                      //color: lightBg,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 5.0, color: lightBg)
                                      ]),
                                  child: Icon(Icons.add, color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 1.21,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: storiesModel.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StoryScreen(
                                          imageUrl: storiesModel[index].image),
                                    ));
                              },
                              child: Container(
                                width: 60,
                                height: 50,
                                padding: EdgeInsets.only(left: 2),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          storiesModel[index].profileImage),
                                      fit: BoxFit.fill),
                                  border: Border.all(color: Colors.greenAccent),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                PostScreenUI()
              ],
            ),
      /*body: isLoading
          ? LoadingScreen()
          : PageView.builder(
              itemCount: reelModel.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return ReelScreenView(
                  reelsModel: reelModel[index],
                );
              },
            ),*/
      bottomNavigationBar: CustomHome(keyword: "home"),
    );
  }
}
