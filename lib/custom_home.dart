import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:reel_app/home_screen/home_screen_ui.dart';
import 'package:reel_app/profile_screen/profile_screen_ui_up.dart';
import 'package:reel_app/reel_screen/short_screen_view.dart';
import 'convert.dart';

class CustomHome extends StatefulWidget {
  const CustomHome(
      {super.key,
      this.animationDuration = const Duration(milliseconds: 170),
      required this.keyword});
  final Duration animationDuration;
  final String keyword;

  // this.animationDuration = const Duration(milliseconds: 170),

  @override
  State<CustomHome> createState() => _CustomHomeState();
}

class _CustomHomeState extends State<CustomHome> {
  final Duration animationDuration = Duration(milliseconds: 170);
  final Curve animationCurve = Curves.linear;
  double iconSize = 35;
  @override
  Widget build(BuildContext context) {
    final double height = 60;
    bool isSelectedCheck = true;
    return Container(
        height: /*height + iconSizeEffectCalculator(iconSize)*/ 50,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                navigationItem("Home", Icons.home_filled,
                    widget.keyword == 'home' ? true : false),
                navigationItem("Reels", Icons.videocam,
                    widget.keyword == 'reel' ? true : false),
                navigationItem("Profile", Icons.person_2,
                    widget.keyword == 'profile' ? true : false),
              ],
            ),
          ),
        )

        //body:
        /*bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [check()],
        ),
      ),*/
        );
  }

  Widget navigationItem(String name, IconData icon, bool isSelected) {
    //bool isSelected = false;
    double tabBarHeight = 60;
    return Expanded(
      child: GestureDetector(
        onForcePressStart: (details) {
          setState(() {});
        },
        onTap: () {
          setState(() {
            isSelected = true;
            //toast("Click " + name + " bool value " + isSelected.toString());
          });
          if (name.contains("Home")) {
            if (widget.keyword.contains("home")) {
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                  (route) => false);
            }

            toast("Home");
          } else if (name.contains("Profile")) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreenUiUp(
                      UserId: FirebaseAuth.instance.currentUser!.uid),
                ));
          } else if (name.contains("Reels")) {
            if (widget.keyword.contains("reel")) {
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShortScreenView(),
                  ),
                  (route) => false);
            }
          }
        },
        child: Container(
          child: Stack(
            clipBehavior: Clip.hardEdge,
            alignment: Alignment.center,
            children: [
              //Icon
              AnimatedAlign(
                alignment: Alignment.center,
                duration: Duration(seconds: 2),
                child: AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(seconds: 2),
                  child: IconTheme(
                      data: IconThemeData(
                          size: 30,
                          color: isSelected
                              ? Color.fromARGB(213, 14, 14, 14)
                              : bm1),
                      child: Icon(
                        icon,
                        size: iconSize,
                      )),
                ),
              ),
              // title  //com.example.reel_app
              /*  AnimatedPositioned(
                curve: animationCurve,
                duration: Duration(milliseconds: 150),
                top: isSelected ? -2.0 * iconSize : tabBarHeight / 4.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: iconSize,
                      height: iconSize,
                    ),
                    CustomPaint(
                      child: SizedBox(
                        width: 80,
                        height: iconSize,
                      ),
                      painter: _CustomPath(Colors.blueAccent, iconSize),
                    )
                  ],
                ),
              ),*/
              /*AnimatedAlign(
                  alignment:
                      isSelected ? Alignment.center : Alignment.bottomCenter,
                  duration: animationDuration,
                  curve: animationCurve,
                  child: AnimatedOpacity(
                      opacity: isSelected ? 1.0 : 0.0,
                      duration: animationDuration,
                      child: DefaultTextStyle.merge(
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        child: /*item.title*/ Text(name),
                      ))),*/
              /*Positioned(
                  bottom: 0,
                  child: CustomPaint(
                    child: SizedBox(
                      width: 80,
                      height: iconSize,
                    ),
                    painter: _CustomPath(Colors.black45, iconSize),
                  )),*/
              /*Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedOpacity(
                    duration: animationDuration,
                    opacity: /* isSelected ? 1.0 : */ 0.0,
                    child: Container(
                      width: 5,
                      height: 5,
                      alignment: Alignment.bottomCenter,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: /*item.activeColor*/ Colors.greenAccent,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    )),
              )*/
            ],
          ),
        ),
      ),
    );
  }

  Widget check() {
    return GestureDetector(
      child: Container(
          child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment.topCenter,
            duration: Duration(seconds: 2),
            child: Text("home"),
          )
        ],
      )),
    );
  }

  /// A method that calculate the effect of [iconSize] on the [height] of the Bottom navigation bar
  double iconSizeEffectCalculator(double size) => size > 30
      ? size * 1.2
      : size > 10
          ? size * .6
          : 0;
}

/// A [CustomPainter] that draws a [FlashyTabBar] background.
class _CustomPath extends CustomPainter {
  _CustomPath(this.backgroundColor, this.iconSize);

  final Color backgroundColor;
  final double iconSize;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.lineTo(0, 0);
    path.lineTo(0, (iconSize * .2) * size.height);
    path.lineTo(1.0 * size.width, (iconSize * .2) * size.height);
    path.lineTo(1.0 * size.width, 1.0 * size.height);
    path.lineTo(0, 0);
    path.close();

    paint.color = backgroundColor;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
