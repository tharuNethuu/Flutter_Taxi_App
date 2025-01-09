import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import this package
import 'package:flutter/material.dart';
import 'package:flutter_taxi_app/controller/auth_controller.dart';
import 'package:flutter_taxi_app/views/driver/car_reg_pages/car_color.dart';
import 'package:flutter_taxi_app/views/driver/car_reg_pages/car_model.dart';
import 'package:flutter_taxi_app/views/driver/car_reg_pages/vehicle_number.dart';
import 'package:flutter_taxi_app/views/driver/driver_home.dart';
import 'package:flutter_taxi_app/views/home.dart';
import 'package:flutter_taxi_app/widgets/green_intro_widget.dart';
import 'package:flutter_taxi_app/widgets/green_intro_widget3.dart';
import 'package:flutter_taxi_app/widgets/green_intro_widget_2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class CarRegistration extends StatefulWidget {
  const CarRegistration({Key? key}) : super(key: key);

  @override
  State<CarRegistration> createState() => _CarRegistrationState();
}

class _CarRegistrationState extends State<CarRegistration> {
  String selectedCarType = "";
  String selectedColor = "";
  TextEditingController vehicalNumberController = TextEditingController();

  PageController pageController = PageController();

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFFFFFFF), // Set page background color to white
      resizeToAvoidBottomInset:
          true, // This ensures the screen adjusts when the keyboard appears
      body: Column(children: [
        Container(
          height: Get.height * 0.4,
          child: Stack(
            children: [
              greenIntroWidget3(),
            ],
          ),
        ),
        Flexible(
          // Use Flexible instead of Expanded
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PageView(
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                CarModelPage(
                  selectedCarModel: selectedCarType,
                  onSelect: (String carModel) {
                    setState(() {
                      selectedCarType = carModel;
                    });
                  },
                ),
                Car_clr(
                  selectedCarColor: selectedColor,
                  onSelect: (String carColor) {
                    setState(() {
                      selectedColor = carColor;
                    });
                  },
                ),
                VehicalNumberPage(
                  controller: vehicalNumberController,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () => isUploading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : FloatingActionButton(
                      onPressed: () {
                        if (currentPage < 2) {
                          pageController.animateToPage(
                            currentPage + 1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeIn,
                          );
                        } else {
                          uploadCarEntry();
                        }
                      },
                      backgroundColor: const Color.fromARGB(255, 255, 217, 0),
                      child:
                          const Icon(Icons.arrow_forward, color: Colors.white),
                    ),
            ),
          ),
        ),
      ]),
    );
  }

  var isUploading = false.obs;

  void uploadCarEntry() async {
    if (FirebaseAuth.instance.currentUser == null) {
      // Handle user not logged in
      print("User is not logged in");
      return;
    }

    isUploading(true);
    Map<String, dynamic> carData = {
      'carType': selectedCarType,
      'carColor': selectedColor,
      'carNumber': vehicalNumberController.text.trim(),
    };

    try {
      bool isUploaded =
          await Get.find<AuthController>().uploadCarEntry(carData);
      if (isUploaded) {
        isUploading(false);
        Get.off(() => DriverHome());
      } else {
        // Handle upload failure
        print("Failed to upload car data");
        isUploading(false);
      }
    } catch (e) {
      // Handle any errors during upload
      print("Error uploading car data: $e");
      isUploading(false);
    }
  }
}
