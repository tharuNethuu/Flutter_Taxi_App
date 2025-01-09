import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_taxi_app/models/user_model/user_model.dart';
import 'package:flutter_taxi_app/views/ProfileSettingScreen.dart';
import 'package:flutter_taxi_app/views/driver/car_registration.dart';
import 'package:flutter_taxi_app/views/driver/driver_home.dart';
import 'package:flutter_taxi_app/views/driver/driver_profile.dart';
import 'package:flutter_taxi_app/views/home.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String userUid = '';
  String verId = '';
  int? resendTokenId;
  bool phoneAuthCheck = false;
  dynamic credentials;

  List<Map<String, dynamic>> driversList = [];

  bool isLoginAsDriver = false;

  var isProfileUploading = false.obs;

  set isLoading(bool isLoading) {}

  // Method to initiate phone authentication
  Future<void> phoneAuth(String phone) async {
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          Get.back(); // Close loading dialog
          await signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.back(); // Close loading dialog
          handleAuthError(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          Get.back(); // Close loading dialog
          verId = verificationId;
          resendTokenId = resendToken;
          phoneAuthCheck = true;
          update();
          Get.snackbar(
            'OTP Sent',
            'An OTP has been sent to your phone number.',
            snackPosition: SnackPosition.TOP,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verId = verificationId;
          update();
        },
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
          'Error', 'Error during phone authentication: ${e.toString()}',
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> signInWithCredential(PhoneAuthCredential credential) async {
    try {
      await _auth.signInWithCredential(credential);
      userUid = _auth.currentUser?.uid ?? '';
      print("Signing in successful, deciding route...");
      await decideRoute();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error signing in: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 4),
      );
    }
  }

  Future<void> verifyOTP(String otp) async {
    log('Verifying OTP...');
    try {
      isProfileUploading.value = true; // Start loading

      credentials = PhoneAuthProvider.credential(
        verificationId: verId,
        smsCode: otp,
      );

      await signInWithCredential(credentials); // Sign in with credentials

      await decideRoute(); // Navigate after success
    } catch (e) {
      Get.snackbar(
        'Error',
        'Invalid OTP. Please try again.',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 4),
      );
    } finally {
      isProfileUploading.value = false; // Stop loading
    }
  }

  // Method to resend the OTP
  Future<void> resendOTP(String phoneNumber) async {
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          Get.back(); // Close loading dialog
          await signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.back();
          handleAuthError(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          Get.back(); // Close loading dialog
          verId = verificationId;
          resendTokenId = resendToken;
          phoneAuthCheck = true;
          update();
          Get.snackbar(
            'OTP Resent',
            'A new OTP has been sent to your phone number.',
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 4),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verId = verificationId;
          update();
        },
        forceResendingToken: resendTokenId,
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Error resending OTP: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 4),
      );
    }
  }

  // Method to handle FirebaseAuth errors
  void handleAuthError(FirebaseAuthException e) {
    String errorMsg;
    switch (e.code) {
      case 'invalid-phone-number':
        errorMsg = 'The phone number entered is invalid!';
        break;
      case 'too-many-requests':
        errorMsg = 'Too many requests. Please try again later.';
        break;
      default:
        errorMsg = e.message ?? 'An unknown error occurred.';
    }
    Get.snackbar(
      'Error',
      errorMsg,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 4),
    );
  }

  var isDecided = false;

  Future<void> decideRoute() async {
    if (isDecided) {
      return;
    } // Prevent duplicate calls
    isDecided = true;
    print("Called");

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No user is logged in.");
      }

      DocumentSnapshot value = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (isLoginAsDriver) {
        if (value.exists) {
          print("Navigating to Driver home page");
          Get.offAll(() => DriverMain());
        } else {
          print("Navigating to DriverProfileSetup");
          Get.offAll(() => DriverProfileSetup());
        }
      } else if (value.exists) {
        print("Navigating to HomeScreen");
        Get.offAll(() => HomeScreen());
      } else {
        print("Navigating to Profilesettingscreen");
        Get.offAll(() => Profilesettingscreen());
      }
    } catch (e) {
      isLoading = false;
      update();
      print("Error while decideRoute is: ${e.toString()}");
    }
  }

  Future<String> uploadImage(File image) async {
    try {
      String fileName = basename(image.path);
      var reference = FirebaseStorage.instance.ref().child('users/$fileName');

      UploadTask uploadTask = reference.putFile(image);
      uploadTask.snapshotEvents.listen((event) {
        double progress =
            (event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *
                100;
        print("Upload is $progress% complete.");
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      print("Download URL: $imageUrl");
      return imageUrl; // Ensure you return the image URL here.
    } on FirebaseException catch (e) {
      print("Firebase Exception: ${e.message}");
      return ''; // Return a default value in case of an error.
    } catch (e) {
      print("General Exception: $e");
      return ''; // Return a default value in case of an error.
    }
  }

  storeUserInfo(File? selectedImage, String name, String home, String business,
      String shop,
      {String url = ''}) async {
    String url_new = url;
    if (selectedImage != null) {
      url = await uploadImage(selectedImage);
    }
    if (selectedImage != null) {
      setState(() {
        isLoading = true;
      });
      try {
        String imageUrl = await url;

        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          String uid = currentUser.uid;

          // Storing data in Firestore
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'image': imageUrl,
            'name': name,
            'home_address': home,
            'business_address': business,
            'shopping_address': shop,
          });

          print("User info added successfully!");

          // Clear controllers after storing data

          isProfileUploading(false);
          Get.offAll(() => HomeScreen());
        } else {
          print("No user is currently signed in.");
        }
      } catch (e) {
        print("Error storing user info: $e");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print("No image selected");
    }
  }

  storeDriverProfile(
    File? selectedImage,
    String name,
    String email, {
    String url = '',
  }) async {
    String url_new = url;
    if (selectedImage != null) {
      url_new = await uploadImage(selectedImage);
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).set(
        {'image': url_new, 'name': name, 'email': email, 'isDriver': true},
        SetOptions(merge: true)).then((value) {
      isProfileUploading(false);

      Get.off(() => CarRegistration());
    });
  }

  Future<bool> uploadCarEntry(Map<String, dynamic> carData) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(carData, SetOptions(merge: true)); // Ensure merge is correct
      return true;
    } catch (e) {
      print("Error in uploadCarEntry: $e");
      return false;
    }
  }

  var myUser = UserModel().obs;

  getUserInfo() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((event) {
      myUser.value = UserModel.fromJson(event.data()!);
    });
  }

  // Fetch data from Firebase
  /* Future<void> fetchDriversFromFirebase() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      setState(() {
        driversList = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print('Error fetching drivers: $e');
    }
  }
 */
  Future<Prediction?> showGoogleAutoComplete(BuildContext context) async {
    const kGoogleApiKey = "AIzaSyBO4VWcabPxLQeRZon_V_ci9QtJRBCtWIo";

    Prediction? p = await PlacesAutocomplete.show(
      offset: 0,
      radius: 1000,
      strictbounds: false,
      region: "lk",
      language: "en",
      context: context,
      mode: Mode.overlay,
      apiKey: kGoogleApiKey,
      components: [new Component(Component.country, "lk")],
      types: ["(cities)"],
      hint: "Search City",
    );

    return p;
  }

  buildLatLngFromAddress(String place) {
    Future<LatLng> buildLatLngFromAddress(String place) async {
      List<geoCoding.Location> locations =
          await geoCoding.locationFromAddress(place);
      return LatLng(locations.first.latitude, locations.first.longitude);
    }
  }

  void setState(Null Function() param0) {}
}
