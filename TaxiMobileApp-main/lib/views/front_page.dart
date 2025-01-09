import 'package:flutter/material.dart';
import 'package:flutter_taxi_app/views/decision_screen/decison_screen.dart'; // Import your DecisionScreen

class FrontPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background GIF
          SizedBox.expand(
            child: Image.asset(
              'assets/background.gif', // Replace with your GIF file in assets
              fit: BoxFit.cover,
            ),
          ),
          // Overlay for darkening the background (optional)
          Container(
            color: Colors.black.withOpacity(0),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Title or Logo
                
                SizedBox(height: 60),
                SizedBox(height: 40),

                // Get Started Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to DecisionScreen when pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DecisonScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.blue[900], // Button color
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, color: Colors.yellow[600]),
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
