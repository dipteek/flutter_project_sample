import 'package:flutter/material.dart';
import 'package:reel_app/custom_home.dart';

class PackScreen extends StatefulWidget {
  const PackScreen({super.key});

  @override
  State<PackScreen> createState() => _PackScreenState();
}

class _PackScreenState extends State<PackScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Pack Screen"),
      //bottomNavigationBar:/CustomHome(),
    );
  }
}
