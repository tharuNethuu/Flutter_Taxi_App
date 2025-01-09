import 'package:flutter/material.dart';
import 'package:flutter_taxi_app/views/decision_screen/decison_screen.dart';
import 'package:flutter_taxi_app/views/rate.dart'; // Import your DecisionScreen

class WaitingPage extends StatelessWidget {
 
   

  const WaitingPage({
    Key? key

  }) : super(key: key); 

  



  
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background GIF
          SizedBox.expand(
            child: Image.asset(
              'assets/waiting.gif', // Replace with your GIF file in assets
              fit: BoxFit.cover,
            ),
          ),
          // Overlay for darkening the background (optional)
         
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 310),
               
              ],
            ),
            SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
               
              ],
            ),
            SizedBox(height: 60),
                

                // Get Started Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to DecisionScreen when pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RatingPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Color.fromARGB(255, 45, 40, 171), // Button color
                  ),
                  child: Text(
                    'Finish Ride',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
