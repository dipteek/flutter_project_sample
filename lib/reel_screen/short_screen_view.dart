import 'package:flutter/material.dart';

import '../custom_home.dart';
import '../home_screen/home_function.dart';
import '../home_screen/reel_screen_view.dart';
import '../loading_screen/loading_screen.dart';
import '../model_classes/reel_model.dart';

class ShortScreenView extends StatefulWidget {
  const ShortScreenView({super.key});

  @override
  State<ShortScreenView> createState() => _ShortScreenViewState();
}

class _ShortScreenViewState extends State<ShortScreenView> {
  List<ReelModel> reelModel = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getReelData();
  }

  void getReelData() async {
    reelModel = await HomeFunction.getReels() ?? [];

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? LoadingScreen()
          : PageView.builder(
              itemCount: reelModel.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return ReelScreenView(
                  reelsModel: reelModel[index],
                );
              },
            ),
      bottomNavigationBar: CustomHome(keyword: "reel"),
    );
  }
}
