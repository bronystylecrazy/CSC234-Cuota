import 'package:cuota/login.dart';
import 'package:cuota/register.dart';
import 'package:cuota/splash.dart';
import 'package:cuota/feed.dart';
import 'package:cuota/profile.dart';
import 'package:cuota/explore.dart';
import 'package:cuota/eventDetail.dart';
import 'package:cuota/testscroll.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './utils/Dio.dart';

void main() {
  runApp(const MyApp());
  DioManager.register();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const nameApplication = "CUOTA";

  static const BGMain1 = Color.fromARGB(255, 37, 73, 121);
  static const BGMain2 = Color.fromARGB(255, 47, 57, 106);
  static const BGMain3 = Color.fromARGB(255, 63, 24, 81);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CUOTA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.openSansTextTheme()),
      home: Splash(),
    );
  }
}
