import 'dart:developer';

import 'package:android_muzik/screens/welcome_screen/utils/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../constants/styling.dart';
import '../../providers/loading_provider.dart';
import '../../providers/location_provider.dart';
import '../../utils/get_location.dart';
import '../email_sign_in_screen/email_sign_in_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static String routeName = '/welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoginProgress = false;
  late String fcmToken;
  late Map<String, double> location;

  @override
  void initState() {
    _getPermission();
    super.initState();
  }

  void _getPermission() async {
    final LocationProvider locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    location = await getLocation(context);
    final status = await Permission.storage.request();
    log('is Granted:${status.isGranted}');
    locationProvider.setLocation(location);
    await Permission.mediaLibrary.request();
    log('latitude: ${location['latitude'].toString()}');
  }

  void _googleSignIn() async {
    final LoadingProvider loadingProvider =
        Provider.of<LoadingProvider>(context, listen: false);
    setState(() {
      _isLoginProgress = true;
    });
    loadingProvider.setIsGoogleLogin(true);
    googleSignIn(location);
    setState(() {
      _isLoginProgress = false;
    });
  }

  void _emailSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmailSingInScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoginProgress,
        child: SizedBox(
          height: screenHeight(context),
          child: Stack(
            children: [
              SizedBox(
                width: screenWidth(context),
                child: Image.asset(
                  'assets/images/pngs/login_background_image.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: screenHeight(context) * 0.48,
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth(context) * 0.05),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black,
                        Colors.black,
                        Colors.black,
                        Colors.black,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Dancing between\nThe shadow\nOf rhythm',
                            style: TextStyle(
                                color: textHeadingColor,
                                fontSize: screenWidth(context) * 0.085,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight(context) * 0.02),
                      ElevatedButton(
                        style: registerButtonStyle(
                          context,
                          redColor,
                          redColor,
                        ),
                        onPressed: _googleSignIn,
                        child: Text(
                          'Google',
                          style: TextStyle(
                            color: blackColor,
                            fontSize: screenWidth(context) * 0.045,
                            // fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight(context) * 0.015),
                      ElevatedButton(
                        style: registerButtonStyle(
                          context,
                          Colors.transparent,
                          redColor,
                        ),
                        onPressed: _emailSignUp,
                        child: Text(
                          'Continue with Email',
                          style: TextStyle(
                            color: redColor,
                            fontSize: screenWidth(context) * 0.04,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'by continuing you agree to terms\nof services and Privacy policy',
                        style: TextStyle(color: textHeadingColor),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight(context) * 0.03),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
