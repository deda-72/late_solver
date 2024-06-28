import 'package:flutter/material.dart';
import 'hidden_text_field.dart'; // Import your custom HiddenTextField widget

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
      body: Container(
        child: Center(
          child: HiddenTextField(
            // Use the HiddenTextField widget here
            onKeyboardPresented: () {
              setState(() {
                isKeyboardPresented = true;
              });
            },
          ),
        ),
      ),
    );
  }
}
