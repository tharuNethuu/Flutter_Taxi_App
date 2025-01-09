import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import this package
import 'package:flutter/material.dart';
import 'package:flutter_taxi_app/controller/auth_controller.dart';
import 'package:flutter_taxi_app/views/home.dart';
import 'package:flutter_taxi_app/widgets/green_intro_widget.dart';
import 'package:flutter_taxi_app/widgets/green_intro_widget_2.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController homeController = TextEditingController();
  TextEditingController buisnessController = TextEditingController();
  TextEditingController shopController = TextEditingController();

  AuthController authController = Get.find<AuthController>();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  getImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        selectedImage = File(image.path);
        setState(() {});
        print('Image selected: ${selectedImage!.path}');
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.text = authController.myUser.value.name ?? "";
    homeController.text = authController.myUser.value.hAddress?? "";
    buisnessController.text = authController.myUser.value.bAddress?? "";
    shopController.text = authController.myUser.value.mallAddress?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Get.height * 0.4,
              child: Stack(
                children: [
                  greenIntroWidget2(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                        onTap: () {
                          getImage(ImageSource.camera);
                        },
                        child: selectedImage == null
                            ? Container(
                                width: 130,
                                height: 130,
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white54,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 40,
                                    color: Color.fromARGB(255, 6, 96, 199),
                                  ),
                                ),
                              )
                            : Container(
                                width: 130,
                                height: 130,
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(selectedImage!),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: BoxShape.circle,
                                  color: Colors.white54,
                                ),
                              )),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 23),
              child: Column(
                children: [
                  TextFieldWidget(
                      'Name', Icons.person_outlined, nameController),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    'Home Address',
                    Icons.home_outlined,
                    homeController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    'Business Address',
                    Icons.card_travel,
                    buisnessController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    'Shopping Center',
                    Icons.shopping_cart_outlined,
                    shopController,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Obx(
                    () => authController.isProfileUploading.value
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : submitButton('Update', () {
                            
                            
                             authController.isProfileUploading(true);


                            authController.storeUserInfo(
                                selectedImage,
                                nameController.text,
                                homeController.text,
                                buisnessController.text,
                                shopController.text);
                          }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TextFieldWidget(
    String title, IconData iconData, TextEditingController controller) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(
      title,
      style: GoogleFonts.poppins(
          fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
    ),
    const SizedBox(
      height: 6,
    ),
    Container(
      width: Get.width,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 1,
            )
          ],
          borderRadius: BorderRadius.circular(8)),
      child: TextField(
        controller: controller,
        style: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(
              iconData,
              color: Color.fromARGB(255, 224, 147, 2),
            ),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 15), // Adjust padding here
          border: InputBorder.none,
        ),
      ),
    ),
  ]);
}

Widget submitButton(String title, Function onPressed) {
  return MaterialButton(
    minWidth: Get.width,
    height: 50,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    color: Color(0xff0048aa),
    onPressed: () => onPressed(),
    child: Text(
      title,
      style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 240, 163, 10)),
    ),
  );
}