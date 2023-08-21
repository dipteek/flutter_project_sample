import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math';

const primaryColor = Color(0xFFc683e5);
const foregroundColor = Color(0xFFFF9818);
Color c1 = const Color(0xFF42A5F5);

Color bm1 = Color.fromARGB(118, 41, 42, 42);

Color lightBg = Color.fromARGB(52, 41, 42, 42);

String generatedId() {
  final random = Random.secure();
  final values = List<int>.generate(25, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}
