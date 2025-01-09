/* import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_taxi_app/views/driver/driverBookings.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({Key? key}) : super(key: key);

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? carType, carNumber, name, email;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        carType = userDoc['carType'];
        carNumber = userDoc['carNumber'];
        name = userDoc['name'];
        email = userDoc['email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/driverHome.png',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Wrap in Center widget for proper alignment

                const SizedBox(height: 50),
                // Show a loading spinner while data is being fetched
                carType == null ||
                        carNumber == null ||
                        name == null ||
                        email == null
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          Text(
                            'Name: $name',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          Text(
                            'Email: $email',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          Text(
                            'Car Type: $carType',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          Text(
                            'Car Number: $carNumber',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 1, 50, 99),
        selectedItemColor: Colors.yellow[700],
        unselectedItemColor: Color.fromARGB(221, 255, 255, 255),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
            Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DriverHome()),
      );
            break;
            case 1:
              DriverBookings();
              break;
            case 2:
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DriverBookings()),
      );
          }
        },
      ),
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverMain extends StatefulWidget {
  const DriverMain({Key? key}) : super(key: key);

  @override
  State<DriverMain> createState() => _DriverMainState();
}

class _DriverMainState extends State<DriverMain> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    DriverHome(),
    Center(
        child: Text('Notifications Page')), // Replace with Notifications page
    DriverBookings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 0, 11, 61),
        selectedItemColor: Colors.yellow[700],
        unselectedItemColor: const Color.fromARGB(221, 255, 255, 255),
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}

class DriverHome extends StatefulWidget {
  const DriverHome({Key? key}) : super(key: key);

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? carType, carNumber, name, email;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        carType = userDoc['carType'];
        carNumber = userDoc['carNumber'];
        name = userDoc['name'];
        email = userDoc['email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      SizedBox.expand(
        child: Image.asset(
          'assets/driverHome.png',
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(height: 20),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Wrap in Center widget for proper alignment

            const SizedBox(height: 50),
            // Show a loading spinner while data is being fetched
            carType == null ||
                    carNumber == null ||
                    name == null ||
                    email == null
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      Text(
                        'Name: $name',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      Text(
                        'Email: $email',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      Text(
                        'Car Type: $carType',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      Text(
                        'Car Number: $carNumber',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ],
                  ),
          ],
        ),
      ),
      const SizedBox(height: 40),
    ]));
  }
}

class DriverBookings extends StatefulWidget {
  const DriverBookings({Key? key}) : super(key: key);

  @override
  State<DriverBookings> createState() => _DriverBookingsState();
}

class _DriverBookingsState extends State<DriverBookings> {
  
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/driverBooking.png',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
      
    );
  }
}

