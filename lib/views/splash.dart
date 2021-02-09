import 'dart:async';
import 'package:flutter/material.dart';
import '../common/color_constants.dart';
import '../common/constants.dart';
import '../common/route_generator.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double height, width;

  @override
  void initState() {
    super.initState();
    loginCheck();
  }

  void loginCheck() async {
    var _duartion = new Duration(
      seconds: Constants.SPLASH_SCREEN_TIME,
    );
    Timer(_duartion, () async {
      Navigator.of(context).pushNamedAndRemoveUntil(
        EventMain,
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorConstants.kPrimaryColor,
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width / 10, vertical: height / 5),
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          Container(
            child: Text(
              "Event",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: ColorConstants.kWhiteColor,
              ),
            ),
          ),
          Container(
            child: Text(
              "Manger",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: ColorConstants.kWhiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
