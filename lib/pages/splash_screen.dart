import 'package:flutter/material.dart';
import 'package:smart_wallet/pages/log_in.dart';
import 'package:smart_wallet/pages/onboarding/onboarding.dart';
import 'package:smart_wallet/utils/helpers/helper_functions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_wallet/utils/theme/theme.dart';

import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = Duration(seconds: 2);
    Timer(duration, () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration:
                Duration(milliseconds: 850), // Adjust the duration as needed
            pageBuilder: (_, __, ___) => const OnBoardingScreen(),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Stack(
                children: [
                  FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 1.0,
                        end: 0.0,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      )),
                      child: child,
                    ),
                  ),
                  FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.5,
                        end: 1.0,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      )),
                      child: const OnBoardingScreen(),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.wallet,
              size: 100,
              color: Color(0xFF204683),
            ),
            SizedBox(height: 30.0),
            Text(
              "Smart Wallet",
              style: TextStyle(
                color: Color(0xFF0988C3),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
