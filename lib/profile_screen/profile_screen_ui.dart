import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreenUI extends StatefulWidget {
  const ProfileScreenUI({super.key});

  @override
  State<ProfileScreenUI> createState() => _ProfileScreenUIState();
}

class _ProfileScreenUIState extends State<ProfileScreenUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Text(
                  "User Profile",
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz_rounded))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 90.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[400], shape: BoxShape.circle),
                ),
                showDetails("Posts", "0"),
                showDetails("Followers", "0"),
                showDetails("Following", "0"),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          customButton()
        ],
      ),
    );
  }

  Widget showDetails(String txtContain, String numericContain) {
    return Column(
      children: [
        Text(numericContain,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
        Text(txtContain,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500))
      ],
    );
  }

  Widget customButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blueGrey[400]),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text("Edit Profile",
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
          ),
        ),
      ),
    );
  }
}
