import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reel_app/home_screen/home_screen_ui.dart';
import 'package:reel_app/login_screen/login_function.dart';
import 'package:reel_app/signup_screen/signup_screen_ui.dart';

class LoginScreenUI extends StatefulWidget {
  const LoginScreenUI({super.key});

  @override
  State<LoginScreenUI> createState() => _LoginScreenUIState();
}

class _LoginScreenUIState extends State<LoginScreenUI> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  void onLogin() async {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      bool isAcountLogin =
          await LoginFunction().login(email.text, password.text);
      if (isAcountLogin) {
        print("Account Created Successfully");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
            (route) => false);
      } else {
        print("Something wrong");
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: /*double.infinity*/ 360.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Reel",
              style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w500),
            ),
            customField("Email", email),
            customField("Password", password),
            SizedBox(
              height: 20.h,
            ),
            customButton()
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 30.h,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "New User?",
            style: TextStyle(fontSize: 15.sp),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const  SignupScreen(),
                  ));
            },
            child: Text(
              " SignUp",
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp),
            ),
          )
        ]),
      ),
    );
  }

  Widget customButton() {
    return InkWell(
      onTap: onLogin,
      child: Container(
        alignment: Alignment.center,
        width: 310.w,
        height: 40.h,
        decoration: BoxDecoration(
            color: Colors.blue[700],
            borderRadius: BorderRadius.all(Radius.circular(20.r))),
        child: Text(
          "Login",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.sp),
        ),
      ),
    );
  }

  Widget customField(String hintText, TextEditingController controller) {
    return SizedBox(
      width: 360.w /*double.infinity*/,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
