import 'package:flutter/material.dart';
import 'package:flutter_taxi_app/views/decision_screen/decison_screen.dart';
import 'package:flutter_taxi_app/views/home.dart'; // Import your DecisionScreen

class RatingPage extends StatefulWidget {
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int? selectedRating; // Variable to store the selected rating (1 to 5)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background GIF
          SizedBox.expand(
            child: Image.asset(
              'assets/rating.png', // Replace with your GIF file in assets
              fit: BoxFit.cover,
            ),
          ),
          // Overlay for darkening the background (optional)
          
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 250),
                // Title Text
                Text(
                  'Share your experience by rating us!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20), // Space between title and stars

                // Star Rating Widget
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        Icons.star,
                        color: selectedRating != null && index < selectedRating! 
                            ? Colors.amber 
                            : Color.fromARGB(255, 177, 175, 175), // Change to yellow if selected
                        size: 40,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedRating = index + 1; // Update rating on press
                        });
                      },
                    );
                  }),
                ),

                // Optional: Show selected rating
                if (selectedRating != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'You rated us $selectedRating star${selectedRating! > 1 ? 's' : ''}!',
                      style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 14, 9, 9)),
                    ),
                  ),

                // Optional: Navigate button to next screen
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to decision screen after rating
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Text(
                      'Submit Rating',
                      style: TextStyle(color:Color.fromARGB(255, 255, 255, 255)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 45, 40, 171), // Button color
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
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
