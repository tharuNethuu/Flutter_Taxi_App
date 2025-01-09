import 'package:flutter/material.dart';
import 'package:flutter_taxi_app/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_taxi_app/widgets/otp_verification_widget.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  OtpVerificationScreen(this.phoneNumber);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    authController.phoneAuth(widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/otpbg.png', // Ensure this path is correct
              fit: BoxFit.cover,
            ),
          ),

          // Main content
          Positioned.fill(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 140), // Start content 80 pixels from top
                    // Back button
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Color.fromARGB(255, 255, 217, 0),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // The rest of your OTP content
                    Expanded(
                      child: Stack(
                        children: [
                        otpVerificationWidget(), // Your OTP widget
                        Obx(
                          () => authController.isProfileUploading.value
                              ? Center(child: CircularProgressIndicator())
                              : SizedBox.shrink(),
                        ),
                      ],

                      ),
                      
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
