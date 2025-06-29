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

class _LoginScreenUIState extends State<LoginScreenUI>
    with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void onLogin() async {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      bool isAccountLogin =
      await LoginFunction().login(email.text, password.text);
      if (isAccountLogin) {
        print("Account Login Successfully");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
                (route) => false);
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Login failed. Please check your credentials.'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all fields'),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.indigo.shade100,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: Column(
                                children: [
                                  // Logo/App Name Section
                                  Container(
                                    padding: EdgeInsets.all(16.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.play_circle_filled,
                                      size: 50.sp,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    "Reel",
                                    style: TextStyle(
                                      fontSize: 42.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    "Welcome back!",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 30.h),
                                ],
                              ),
                            ),
                          ),

                          // Form Section
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              children: [
                                customField(
                                  "Email",
                                  email,
                                  Icons.email_outlined,
                                  TextInputType.emailAddress,
                                ),
                                SizedBox(height: 16.h),
                                customField(
                                  "Password",
                                  password,
                                  Icons.lock_outline,
                                  TextInputType.visiblePassword,
                                  isPassword: true,
                                ),
                                SizedBox(height: 12.h),

                                // Forgot Password
                                // Align(
                                //   alignment: Alignment.centerRight,
                                //   child: TextButton(
                                //     onPressed: () {
                                //       // Handle forgot password
                                //     },
                                //     child: Text(
                                //       "Forgot Password?",
                                //       style: TextStyle(
                                //         color: Colors.blue.shade700,
                                //         fontSize: 14.sp,
                                //         fontWeight: FontWeight.w500,
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                SizedBox(height: 20.h),
                                customButton(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Flexible spacing
                    SizedBox(height: 30.h),

                    // Bottom Section
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade400,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                "or",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.shade400,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "New to Reel? ",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customButton() {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade600,
            Colors.blue.shade800,
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onLogin,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
              height: 24.h,
              width: 24.w,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.login,
                  color: Colors.white,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customField(
      String hintText,
      TextEditingController controller,
      IconData icon,
      TextInputType inputType, {
        bool isPassword = false,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        obscureText: isPassword && !isPasswordVisible,
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.grey.shade800,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 16.sp,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.grey.shade600,
            size: 20.sp,
          ),
          suffixIcon: isPassword
              ? IconButton(
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
            icon: Icon(
              isPasswordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey.shade600,
              size: 20.sp,
            ),
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(
              color: Colors.blue.shade700,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 18.h,
          ),
        ),
      ),
    );
  }
}