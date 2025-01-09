            import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_taxi_app/views/otp_verification_screen.dart';
import 'package:get/get.dart';
import '../widgets/green_intro_widget.dart';
import '../widgets/login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final countryPicker = const FlCountryCodePicker();
  CountryCode countryCode =
      CountryCode(name: 'Sri Lanka', code: 'LK', dialCode: '+94');

  onSubmit(String? input) {
    Get.to(() => OtpVerificationScreen(countryCode.dialCode + input!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/background.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),

          // Main content
          Positioned.fill(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 220), // Add padding here
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // greenIntroWidget(),
                    const SizedBox(height: 10),
                    loginWidget(
                      countryCode,
                      () async {
                        final picked =
                            await countryPicker.showPicker(context: context);
                        if (picked != null) countryCode = picked;
                        setState(() {});
                      },
                      onSubmit,
                    ),
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
