import 'package:flutter/material.dart';
import 'package:flutter_taxi_app/controller/auth_controller.dart';
import 'package:flutter_taxi_app/views/ProfileSettingScreen.dart';
import 'package:flutter_taxi_app/views/decision_screen/decison_screen.dart';
import 'package:flutter_taxi_app/views/driver/car_registration.dart';
import 'package:flutter_taxi_app/views/front_page.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import './views/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    authController.decideRoute();
    final textTheme = Theme.of(context).textTheme;

    return GetMaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(textTheme),
      ),
      home: FrontPage(),
    );
  }
}
