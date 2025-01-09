import 'package:flutter/material.dart';
import 'package:flutter_taxi_app/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class RoundedPinputWithShadow extends StatelessWidget {
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromARGB(255, 119, 118, 118),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(0, 158, 158, 158)
                .withOpacity(0.5), // Shadow color
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
    );

    return Scaffold(
      body: Center(
        child: Pinput(
          length: 6, // Number of input fields

          onCompleted: (String input) {
            authController.verifyOTP(input);
          },

          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              border:
                  Border.all(color: Colors.blue), // Border color when focused
            ),
          ),
          submittedPinTheme: defaultPinTheme,
          showCursor: true,
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RoundedPinputWithShadow(),
  ));
}
