import 'package:flutter/material.dart';
import 'package:flutter_taxi_app/views/waiting.dart';

class BookingDetailsPage extends StatefulWidget {
  final travelTime;
  final double distanceInKm;

  const BookingDetailsPage(
      {Key? key,
      required this.travelTime,
      required this.distanceInKm})
      : super(key: key);

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  String? selectedPaymentMethod; // To track the selected payment method

  void _onConfirm() {
    if (selectedPaymentMethod == null) {
      // Show a message if no payment method is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a payment method')),
      );
    } else {
      print('Travel Time in booking page: ${widget.travelTime}');
      print('Distance in booking page: ${widget.distanceInKm}');

      // Navigate to the home page if a payment method is selected
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => WaitingPage( )), 
                    // Replace with your home page widget
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background GIF
          SizedBox.expand(
            child: Image.asset(
              'assets/booking.png', // Replace with your GIF or image file in assets
              fit: BoxFit.cover,
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Payment Method Selection Box
                const SizedBox(height: 500),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Payment Method',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Align items in the center horizontally
                          children: [
                            // First payment option (e.g., Credit Card)
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Credit Card',
                                  groupValue: selectedPaymentMethod,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedPaymentMethod = value;
                                    });
                                  },
                                ),
                                Text('Credit Card'),
                              ],
                            ),

                            SizedBox(
                                width: 20), // Space between the two options

                            // Second payment option (e.g., Cash on Delivery)
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Cash on Delivery',
                                  groupValue: selectedPaymentMethod,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedPaymentMethod = value;
                                    });
                                  },
                                ),
                                Text('Cash on Delivery'),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                SizedBox(height: 20),
                // Complete Booking Button
                ElevatedButton(
                  onPressed: _onConfirm,
                  child: Text(
                    'Complete Booking',
                    style: TextStyle(
                      color: Colors.white, // Set text color here
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        255, 45, 40, 171), // Button background color
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: const StadiumBorder(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
