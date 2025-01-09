import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_taxi_app/utills/app_constants.dart';
import 'package:flutter_taxi_app/widgets/text_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_taxi_app/widgets/pinput_widget.dart';

Widget otpVerificationWidget() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
/*         textWidget(text: AppConstants.phoneVerification, fontSize: 16, FontWeight: FontWeight.bold, height: 1.5),
 */
        textWidget(
          text: AppConstants.enterOtp,
          fontSize: 26,
          color: const Color.fromRGBO(255, 171, 0, 1),
          FontWeight: FontWeight.bold,
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
            width: Get.width, height: 50, child: RoundedPinputWithShadow()),
        const SizedBox(
          height: 30,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: GoogleFonts.poppins(
                        color: Color.fromARGB(255, 235, 200, 4), fontSize: 12),
                    children: [
                      TextSpan(
                        text: AppConstants.resendCode + " ",
                      ),
                      TextSpan(
                          text: "10 seconds.",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    ])))
      ],
    ),
  );
}
