import 'package:accii/Presentation/widgets/basicWidgets/Buttons/custonButton.dart';
import 'package:accii/Presentation/widgets/basicWidgets/TextFields/customTextField.dart';
import 'package:flutter/material.dart';

class Overview_page extends StatefulWidget {
   Overview_page({super.key});

  @override
  State<Overview_page> createState() => _Overview_pageState();
}

class _Overview_pageState extends State<Overview_page> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Home Page',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 20), // Add some spacing between the text and the image
            Image.asset(
              'assets/car.png', // Replace with the actual path to your image asset
              width: 400, // Adjust the width and height as needed
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}
