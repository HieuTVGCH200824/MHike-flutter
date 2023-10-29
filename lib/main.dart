//this is an app that allow the user to record the hike which includes:
// Name of hike (e.g. "Snowdon•, "Trosley Country park", etc.) — Required field
// Location - Required field
// Date of the hike - Required field
// Parking available (i.e. "Yes" or "NO") - Required field
// Length the hike - Required field
// Level of difficulty - Required field
// Description — Optional field

//the app has a floating button, upon click it shows a dialog that let the user to add new hike


//write the complete code for the app here
import 'package:flutter/material.dart';
import 'my_home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hike App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Hike App'),
    );
  }
}
