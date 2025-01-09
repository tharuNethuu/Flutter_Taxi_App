import 'package:flutter/material.dart';
import 'package:flutter_taxi_app/controller/auth_controller.dart';
import 'package:flutter_taxi_app/views/driver/car_registration.dart';
import 'package:flutter_taxi_app/views/login_screen.dart';
import 'package:flutter_taxi_app/widgets/mybutton.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class DecisonScreen extends StatelessWidget {
  DecisonScreen({super.key});

  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/decision_background.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),

          // Main content
          Positioned.fill(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 220), // Add padding here
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // greenIntroWidget(),
                    const SizedBox(height: 50),

                    DecisionButton(
                        'assets/passenger_icon.png', 'Login as a Passenger',
                        () {
                      authController.isLoginAsDriver = false;
                      Get.to(() => LoginScreen());
                    }, Get.width * 0.8),

                    const SizedBox(height: 20),

                    DecisionButton(
                        'assets/driver_icon.png', 'Login as a Driver', () {
                      authController.isLoginAsDriver = true;
                      Get.to(() => LoginScreen());

                    }, Get.width * 0.8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
