import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_taxi_app/controller/auth_controller.dart';
import 'package:flutter_taxi_app/views/BookingDetails.dart';
import 'package:flutter_taxi_app/views/my_profile.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_webservice/places.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'dart:ui' as ui;
import 'dart:math';

import '../widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _mapStyle;

  List<Map<String, dynamic>> driversList = [];

  final Map<String, String> carTypeImages = {
    'Bajaj RE Compact': 'assets/bajaj.png',
    'TVS King': 'assets/TVS.png',
    'Mahindra Alfa': 'assets/mahindra.png',
    'Toyota Prius': 'assets/prius.png',
    'Toyota Corolla Axio': 'assets/corolla.png',
  };

  late LatLng destination;
  late LatLng source;
  final Set<Polyline> _polyline = {};

  Set<Marker> markers = Set<Marker>();

  AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    fetchDriversFromFirebase();

    authController.getUserInfo();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    loadCustomMarker();
  }

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GoogleMapController? myMapController;

  double travelTime = 0.0; // Default value
  double distanceInKm = 0.0; // Default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
      body: Stack(
        children: [
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: GoogleMap(
              markers: markers,
              polylines: _polyline,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                myMapController = controller;
                myMapController!.setMapStyle(_mapStyle);
              },
              initialCameraPosition: _kGooglePlex,
            ),
          ),
          buildProfileTile(),
          buildTextField(),
          showSourceField
              ? buildTextFieldForSource(travelTime, distanceInKm)
              : Container(),
          buildCurrentLocationIcon(),
          buildNotificationIcon(),
          buildBottomSheet(),
        ],
      ),
    );
  }

  Widget buildProfileTile() {
    return Positioned(
      top: 60,
      left: 20,
      right: 20,
      child: Obx(() => authController.myUser.value.name == null?.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: Get.width,
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/person.png'),
                          fit: BoxFit.fill),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'Good Morning, ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14)),
                            TextSpan(
                              text: authController.myUser.value.name,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 6, 96, 199),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          "Where are you going?",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
    );
  }

  Future<String> showGoogleAutoComplete() async {
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

    return p!.description!;
  }

  TextEditingController destinationController = TextEditingController();
  TextEditingController sourceController = TextEditingController();

  bool showSourceField = false;

  Widget buildTextField() {
    return Positioned(
        top: 170,
        left: 20,
        right: 20,
        child: Container(
          width: Get.width,
          height: 50,
          padding: EdgeInsets.only(left: 15, top: 4),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 4,
                    blurRadius: 10)
              ],
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            controller: destinationController,
            readOnly: true,
            onTap: () async {
              String selectedPlace = await showGoogleAutoComplete();

              destinationController.text = selectedPlace;

              List<geoCoding.Location> locations =
                  await geoCoding.locationFromAddress(selectedPlace);

              destination =
                  LatLng(locations.first.latitude, locations.first.longitude);

              markers.add(Marker(
                markerId: MarkerId(selectedPlace),
                infoWindow: InfoWindow(
                  title: 'Destination: $selectedPlace',
                ),
                position: destination,
                icon: BitmapDescriptor.fromBytes(markIcons),
              ));

              myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: destination, zoom: 14)));

              setState(() {
                showSourceField = true;
              });
            },
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: 'Search for a destination',
              hintStyle: GoogleFonts.poppins(fontSize: 16),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.search,
                ),
              ),
              border: InputBorder.none,
            ),
          ),
        ));
  }

  Widget buildTextFieldForSource(travelTime, distanceInKm) {
    return Positioned(
        top: 230,
        left: 20,
        right: 20,
        child: Container(
          width: Get.width,
          height: 50,
          padding: EdgeInsets.only(left: 15, top: 4),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 4,
                    blurRadius: 10)
              ],
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            controller: sourceController,
            readOnly: true,
            onTap: () async {
              Get.bottomSheet(Container(
                width: Get.width,
                height: Get.height * 0.5,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Select Your Location",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Home Address",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: Get.width,
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              spreadRadius: 4,
                              blurRadius: 10,
                            )
                          ]),
                      child: Row(
                        children: [
                          Text(
                            "Pallekele, KANDY",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Business Address",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: Get.width,
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              spreadRadius: 4,
                              blurRadius: 10,
                            )
                          ]),
                      child: Row(
                        children: [
                          Text(
                            "Peradeniya, KANDY",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        Get.back();
                        String place = await showGoogleAutoComplete();
                        sourceController.text = place;

                        List<geoCoding.Location> locations =
                            await geoCoding.locationFromAddress(place);

                        source = LatLng(locations.first.latitude,
                            locations.first.longitude);

                        if (markers.length >= 2) {
                          markers.remove(markers.last);
                        }

                        markers.add(Marker(
                            markerId: MarkerId(place),
                            infoWindow: InfoWindow(
                              title: 'Source: $place',
                            ),
                            position: source));

                        drawPolyline(place);

                        myMapController!.animateCamera(
                            CameraUpdate.newCameraPosition(
                                CameraPosition(target: source, zoom: 14)));
                        setState(() {});
                        buildRideConfirmationSheet(travelTime, distanceInKm);
                      },
                      child: Container(
                        width: Get.width,
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                spreadRadius: 4,
                                blurRadius: 10,
                              )
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Search for Address",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
            },
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: 'From:',
              hintStyle: GoogleFonts.poppins(fontSize: 16),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.search,
                ),
              ),
              border: InputBorder.none,
            ),
          ),
        ));
  }

  Widget buildCurrentLocationIcon() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 8),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Color.fromARGB(255, 6, 96, 199),
          child: Icon(Icons.my_location, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildNotificationIcon() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, left: 8),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(Icons.notifications, color: Color(0xffC3CDD6)),
        ),
      ),
    );
  }

  Widget buildBottomSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: Get.width * 0.7,
        height: 25,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 4,
                blurRadius: 10,
              )
            ],
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12), topLeft: Radius.circular(12))),
        child: Center(
          child: Container(
            width: Get.width * 0.5,
            height: 3,
            color: Colors.black45,
          ),
        ),
      ),
    );
  }

  buildDrawerItem(
      {required String title,
      required Function onPressed,
      Color color = Colors.black,
      double fontSize = 20,
      FontWeight fontWeight = FontWeight.w700,
      double height = 45}) {
    return SizedBox(
      height: height,
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        dense: true,
        onTap: () => onPressed(),
        title: Text(
          title,
          style: GoogleFonts.poppins(
              fontSize: fontSize, fontWeight: fontWeight, color: color),
        ),
      ),
    );
  }

  buildDrawer() {
    return Drawer(
        child: Column(
      children: [
        InkWell(
          onTap: () {
            Get.to(() => const MyProfile());
          },
          child: SizedBox(
            height: 150,
            child: DrawerHeader(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/person.png'),
                            fit: BoxFit.fill)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Good Morning, ',
                          style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.28),
                              fontSize: 14)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 28,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              buildDrawerItem(title: 'Payement History', onPressed: () {}),
              buildDrawerItem(title: 'Ride History', onPressed: () {}),
              buildDrawerItem(title: 'Settings', onPressed: () {}),
              buildDrawerItem(title: 'Support', onPressed: () {}),
              buildDrawerItem(title: 'Logout', onPressed: () {}),
            ],
          ),
        ),
        Spacer(),
        Divider(),
      ],
    ));
  }

  late Uint8List markIcons;

  loadCustomMarker() async {
    markIcons = await loadAsset('assets/dest_marker.png', 100);
  }

  Future<Uint8List> loadAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  /* void drawPolyline(String placeId) {
    _polyline.clear();
    _polyline.add(Polyline(
      polylineId: PolylineId(placeId),
      visible: true,
      points: [source, destination],
      color: Color.fromARGB(255, 3, 82, 172),
      width: 5,
    ));
  } */

  void drawPolyline(String placeId) async {
    _polyline.clear();
    markers.removeWhere((marker) => marker.markerId.value == 'distance_marker');

    // Add the polyline
    _polyline.add(Polyline(
      polylineId: PolylineId(placeId),
      visible: true,
      points: [source, destination],
      color: Color.fromARGB(255, 3, 82, 172),
      width: 5,
    ));

    // Calculate distance
    /* double distanceInMeters = Geolocator.distanceBetween(
    source.latitude,
    source.longitude,
    destination.latitude,
    destination.longitude,
  );
  double distanceInKilometers = distanceInMeters / 1000;

  // Find the midpoint between source and destination
  LatLng midpoint = LatLng(
    (source.latitude + destination.latitude) / 2,
    (source.longitude + destination.longitude) / 2,
  );


  // Add a marker at the midpoint to display the distance
  markers.add(Marker(
    markerId: MarkerId('distance_marker'),
    position: midpoint,
    infoWindow: InfoWindow(
      title: '${distanceInKilometers.toStringAsFixed(2)} km',
      snippet: 'Distance',
    ),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  ));

  setState(() {});  */

    // Calculate the distance

    double distance = calculateDistance(
      source.latitude,
      source.longitude,
      destination.latitude,
      destination.longitude,
    );

    // Find the midpoint of the polyline
    LatLng midpoint = LatLng(
      (source.latitude + destination.latitude) / 2,
      (source.longitude + destination.longitude) / 2,
    );

    // Add a marker at the midpoint to show the distance
    markers.add(Marker(
      markerId: MarkerId('distance_marker'),
      position: midpoint,
      infoWindow: InfoWindow(
        title: '${distance.toStringAsFixed(2)} km',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ));

    setState(() {}); // Update the UI

    //calculate time travel
  }

  buildRideConfirmationSheet(travelTime, distanceInKm) {
    Get.bottomSheet(Container(
      width: Get.width,
      height: Get.height * 0.4,
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12), topLeft: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: Get.width * 0.2,
              height: 8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.grey),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          textWidget(
              text: 'Select an option:',
              fontSize: 18,
              FontWeight: FontWeight.bold),
          const SizedBox(
            height: 20,
          ),
          buildDriversList(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:
                  MainAxisAlignment.end, // Aligns the button to the right
              children: [
                MaterialButton(
                  onPressed: () {
                    // Add your button functionality here
                    // Navigate to the bookingDetails page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookingDetailsPage(
                              travelTime: travelTime,
                              distanceInKm:
                                  distanceInKm)), // Replace BookingDetailsPage with your actual page class
                    );
                  },
                  child: textWidget(
                    text: 'Confirm',
                    color: Colors.white,
                  ),
                  color: Color.fromARGB(255, 45, 40, 171),
                  shape: const StadiumBorder(),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  int selectedRide = 0;

  // Build the drivers list
  Widget buildDriversList() {
    double distance = calculateDistance(
      source.latitude,
      source.longitude,
      destination.latitude,
      destination.longitude,
    );

    double averageSpeed = 40.0; // Average speed in km/h (example: 50 km/h)

    //calculating price
    /*  double price =
        distance * 100; // Price is calculated by multiplying distance by 100
    print("The price is: \$${price.toStringAsFixed(2)}"); */
    return Container(
      height: 150,
      width: 500,
      child: StatefulBuilder(builder: (context, set) {
        return ListView.builder(
          itemBuilder: (ctx, i) {
            String carType = driversList[i]['carType'] ?? 'Unknown';
            double travelTime =
                calculateTravelTime(distance, averageSpeed, carType);
            double price = calculatePrice(distance, carType);
            print(
                'Estimated Travel Time: ${travelTime.toStringAsFixed(2)} hours');
            return InkWell(
              onTap: () {
                set(() {
                  selectedRide = i;
                });
              },
              child: buildDriverCard(
                selectedRide == i,
                driversList[i]['carType'] ?? 'Unknown',
                price,
                travelTime,
                // Pass driver details
                // Pass carType
              ),
            );
          },
          itemCount: driversList.length,
          scrollDirection: Axis.horizontal,
        );
      }),
    );
  }

  // Build individual driver card
  Widget buildDriverCard(
      bool selected, String carType, double price, double travelTime) {
    String imagePath = carTypeImages[carType] ?? 'assets/default_car.png';
    return Container(
      margin: EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
      height: 190,
      width: 215,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: selected
                    ? Color.fromARGB(255, 45, 40, 171).withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                offset: Offset(0, 5),
                blurRadius: 5,
                spreadRadius: 1)
          ],
          borderRadius: BorderRadius.circular(12),
          color: selected ? Color.fromARGB(255, 45, 40, 171) : Colors.grey),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(
                    text: carType,
                    color: Colors.white,
                    FontWeight: FontWeight.w700,
                    fontSize: 16),
                textWidget(
                    text: '${price.toStringAsFixed(2)} LKR',
                    color: Colors.white,
                    FontWeight: FontWeight.w500,
                    fontSize: 16),
                textWidget(
                    text: '${travelTime.toStringAsFixed(2)} h',
                    color: Colors.white.withOpacity(0.8),
                    FontWeight: FontWeight.normal,
                    fontSize: 16),
              ],
            ),
          ),
          Positioned(
              right: -20,
              top: 20,
              bottom: 0,
              child: Image.asset(imagePath),
              width: 110,
              height: 60)
        ],
      ),
    );
  }

  void fetchDriversFromFirebase() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      setState(() {
        driversList = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .where(
                (driver) => driver.containsKey('carType')) // Skip if no carType
            .toList();
      });
    } catch (e) {
      print('Error fetching drivers: $e');
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371; // Earth's radius in kilometers
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);

            setState(() {
      distanceInKm = distanceInKm;
    });

    return 2 * earthRadius * atan2(sqrt(a), sqrt(1 - a));
  }

  double calculateTravelTime(
      double distanceInKm, double averageSpeedKmPerHour, String carType) {
    // Base travel time calculation
    double travelTime = distanceInKm / averageSpeedKmPerHour;

    // Adjust travel time based on car type
    if (carType == 'Toyota Corolla Axio') {
      travelTime *= 0.8; // Add 10 hours for this car type
    } else if (carType == 'Toyota Prius') {
      travelTime *= 0.6; // Add 10 hours for this car type
    }
    // Add more conditions for other car types if needed
    setState(() {
      travelTime = travelTime;
    });
    return travelTime; // Time in hours
  }

  double calculatePrice(double distance, String carType) {
    // Base price calculation
    double price = distance * 100; // Example: 100 LKR per km

    // Adjust price based on car type
    if (carType == 'Toyota Corolla Axio') {
      price *= 1.4; // Multiply price by 0.4
    } else if (carType == 'Toyota Prius') {
      price *= 1.8; // Multiply price by 0.8
    } else if (carType == 'Mahindra Alfa') {
      price *= 1.05; // Multiply price by 0.05
    }

    return price;
  }
}
