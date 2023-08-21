import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reel_app/loading_screen/loading_screen.dart';
import 'package:reel_app/signup_screen/signup_function.dart';

import '../home_screen/home_screen_ui.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Color c1 = const Color(0xFF42A5F5);
  Color c2 = const Color.fromARGB(0xFF, 0x42, 0xA5, 0xF5);
  Color c3 = Color.fromARGB(146, 124, 85, 221);
  Color c4 = const Color.fromRGBO(66, 165, 245, 1.0);
  bool isLoading = false;

  void onCreateAccount() async {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      bool isAccountCreatedSuccessfull =
          await SignupFunction.createAccount(email.text, password.text);

      if (isAccountCreatedSuccessfull) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
            (route) => false);
        print("Account Created Successfully");
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
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            body: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Reel",
                    style:
                        TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w500),
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
              height: 40.h,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "Already have a account?",
                  style: TextStyle(fontSize: 15.sp),
                ),
                InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  highlightColor: c1,
                  hoverColor: c3,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    " Login",
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
      onTap: onCreateAccount,
      child: Container(
        alignment: Alignment.center,
        width: 345.w,
        height: 40.h,
        decoration: BoxDecoration(
            color: Colors.blue[700],
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Text(
          "Create a account",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp),
        ),
      ),
    );
  }

  Widget customField(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
