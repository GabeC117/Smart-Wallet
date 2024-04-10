import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_wallet/pages/onboarding/onboarding.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:smart_wallet/utils/theme/theme.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:camera/camera.dart';

//for later. for webstuff
import 'package:universal_io/io.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: SW_AppTheme.lightTheme,
      darkTheme: SW_AppTheme.darkTheme,
      //title: 'Login Demo',
      home: const OnBoardingScreen(),
    );
  }
}
