import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_taxi_app/utills/app_constants.dart';
import 'package:flutter_taxi_app/widgets/text_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_taxi_app/views/otp_verification_screen.dart';

Widget loginWidget(
    CountryCode countryCode, Function onCountryChange, Function onSubmit) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        textWidget(
            text: AppConstants.helloNiceToMeetYou,
            fontSize: 16,
            color: Color.fromARGB(255, 235, 200, 4),
            FontWeight: FontWeight.w400,
            height: 1.8),
        textWidget(
            text: AppConstants.getMovingWithHopify,
            fontSize: 26,
            color: Color.fromARGB(255, 233, 184, 6),
            FontWeight: FontWeight.bold,
            height: 1.5),
        const SizedBox(
          height: 35,
        ),
        Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 3,
                  blurRadius: 3,
                ),
              ],
            ),
            child: Row(children: [
              Expanded(
                  flex: 1,
                  child: InkWell(
                      onTap: () => onCountryChange(),
                      child: Container(
                          child: Row(
                        children: [
                          const SizedBox(width: 5),

                          Expanded(
                            child: countryCode.flagImage(),
                          ),
                          textWidget(text: countryCode.dialCode),
                          // const SizedBox(width: 10,),
                          Icon(Icons.keyboard_arrow_down_rounded)
                        ],
                      )))),
              Container(
                width: 1,
                height: 55,
                color: Colors.black.withOpacity(0.2),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    onSubmitted: (String? input) => onSubmit(input),
                    decoration: InputDecoration(
                      hintText: AppConstants.enterMobileNumber,
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ])),
        const SizedBox(
          height: 20,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: GoogleFonts.poppins(
                        color: Color.fromARGB(255, 196, 176, 1), fontSize: 12),
                    children: [
                      TextSpan(
                        text: AppConstants.byCreating + " ",
                      ),
                      TextSpan(
                          text: AppConstants.termsOfServices + " ",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: "and ",
                      ),
                      TextSpan(
                          text: AppConstants.privacypolicy + " ",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold))
                    ])))
      ],
    ),
  );
}
