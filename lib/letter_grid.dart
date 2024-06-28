import 'package:flutter/material.dart';

class LetterGrid extends StatefulWidget {
  @override
  _LetterGridState createState() => _LetterGridState();
}

class _LetterGridState extends State<LetterGrid> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Request focus on text field when the widget is initialized
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  Widget build(BuildContext context) {
    const int rows = 6;
    const int columns = 5;
    const double elementSize = 50.0;
    const double spacing = 10.0;

    // Calculate total width and height of the grid
    double totalWidth = columns * (elementSize + spacing) - spacing;
    double totalHeight = rows * (elementSize + spacing) - spacing;

    return GestureDetector(
      onTap: () {
        // Request focus on tap to ensure keyboard shows
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: totalWidth,
            height: totalHeight,
            child: Stack(
              children: _buildGrid(rows, columns, elementSize, spacing),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGrid(
      int rows, int columns, double elementSize, double spacing) {
    List<Widget> elements = [];

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        elements.add(Positioned(
          left: col * (elementSize + spacing),
          top: row *
              (elementSize + spacing), // Adjust top anchor to row calculation
          child: Container(
            width: elementSize,
            height: elementSize,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
            ),
          ),
        ));
      }
    }
    return elements;
  }
}
