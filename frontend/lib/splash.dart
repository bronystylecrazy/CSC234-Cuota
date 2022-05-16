import 'package:cuota/create_event.dart';
import 'package:cuota/explore.dart';
import 'package:cuota/login.dart';
import 'package:cuota/main.dart';
import 'package:cuota/feed.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(milliseconds: 500), () {});
    var prefs = await SharedPreferences.getInstance();
    // prefs.setString("token",
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxLCJ1c2VybmFtZSI6InNpcmF3aXQiLCJpYXQiOjE2NTI2MTg4NTYsImV4cCI6MTY1MzIyMzY1Nn0.1hs8PcHe4Dj-eIh-MCM6a15ZCVh3sNQK50ug2nsb0kQ");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => const Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.1, 0.5, 0.9],
                  colors: [MyApp.BGMain1, MyApp.BGMain2, MyApp.BGMain3])),
          child: const Center(
            child: Text(
              "Logo",
              style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
