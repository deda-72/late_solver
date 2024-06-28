import 'package:flutter/material.dart';
import 'package:late_solver/letter_grid.dart';
import 'hidden_text_field.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      // home: Scaffold(
      //   body: Padding(
      //     padding: EdgeInsets.only(top: 120.0),
      //     child: LetterGrid(),
      //   ),
      // ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isKeyboardPresented = false; // Track if keyboard is presented

  @override
  void initState() {
    super.initState();
    // Request focus on the hidden TextField when the app starts
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 120.0), // Add padding on top
        child: LetterGrid(),
      ),
    );
  }
}
