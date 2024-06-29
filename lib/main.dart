import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LetterRowScreen(),
    );
  }
}

class LetterRowScreen extends StatefulWidget {
  @override
  _LetterRowScreenState createState() => _LetterRowScreenState();
}

class _LetterRowScreenState extends State<LetterRowScreen> {
  List<List<String>> rows =
      List.generate(6, (_) => List.generate(5, (_) => ''));
  int currentRow = 0; // Keep track of the current row being edited
  bool isFixed = false;

  void updateLetter(int rowIndex, int colIndex, String letter) {
    if (!isFixed) {
      setState(() {
        rows[rowIndex][colIndex] = letter;
      });
    }
  }

  void removeLetter() {
    if (!isFixed) {
      setState(() {
        for (int colIndex = 4; colIndex >= 0; colIndex--) {
          if (rows[currentRow][colIndex].isNotEmpty) {
            rows[currentRow][colIndex] = '';
            break;
          }
        }
      });
    }
  }

  void submit() {
    if (rows[currentRow].contains('')) {
      return; // Do not commit if less than 5 letters entered
    }

    setState(() {
      isFixed = true;
    });
    // Reserve for future function
    onEnterPressed();
  }

  void onEnterPressed() {
    // Future function to be defined here
    print("Row ${currentRow + 1} fixed: ${rows[currentRow].join()}");
    // Move to the next row after submitting
    if (currentRow < rows.length - 1) {
      setState(() {
        currentRow++;
        isFixed = false; // Reset the fixed state for the next row
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WORDL Late Solver'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: rows.length,
              itemBuilder: (context, rowIndex) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (colIndex) {
                      return Container(
                        width: 60.0, // Fixed width
                        height: 60.0, // Fixed height to make it square
                        margin: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.white, // White background
                          border: Border.all(
                            color: Colors.black, // Black border
                            width: 2.0, // Border width
                          ),
                          borderRadius:
                              BorderRadius.circular(8.0), // Rounded corners
                        ),
                        child: Center(
                          child: Text(
                            rows[rowIndex][colIndex],
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
          Keyboard(
            onLetterSelected: (letter) {
              if (!isFixed && currentRow < rows.length) {
                for (int i = 0; i < rows[currentRow].length; i++) {
                  if (rows[currentRow][i].isEmpty) {
                    updateLetter(currentRow, i, letter);
                    break;
                  }
                }
              }
            },
            onBackspace: removeLetter,
            onEnter: submit,
          ),
        ],
      ),
    );
  }
}

class Keyboard extends StatelessWidget {
  final Function(String) onLetterSelected;
  final VoidCallback onBackspace;
  final VoidCallback onEnter;

  Keyboard({
    required this.onLetterSelected,
    required this.onBackspace,
    required this.onEnter,
  });

  final List<String> qwertyRows = [
    'QWERTYUIOP',
    'ASDFGHJKL',
    'ZXCVBNM',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Define key size based on screen width
        double keyWidth = (constraints.maxWidth - 20) /
            10 *
            0.8; // Decrease key width by factor 0.8
        double keyHeight = 40.0;

        return Container(
          color: Colors.grey[200],
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...qwertyRows.map((row) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.split('').map((letter) {
                    return _buildKey(letter, keyWidth, keyHeight);
                  }).toList(),
                );
              }).toList(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSpecialKey(
                      Icons.backspace, onBackspace, keyWidth, keyHeight),
                  _buildSpecialKey(Icons.check, onEnter, keyWidth, keyHeight,
                      text: 'Enter'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKey(String letter, double width, double height) {
    return GestureDetector(
      onTap: () => onLetterSelected(letter),
      child: Container(
        margin: EdgeInsets.all(2.0),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialKey(
      IconData icon, VoidCallback onTap, double width, double height,
      {String? text}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(2.0),
        width: width * 1.5, // Special keys are 1.5 times wider
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: text != null
              ? Text(
                  text,
                  style: TextStyle(fontSize: 20),
                )
              : Icon(
                  icon,
                  size: 24,
                ),
        ),
      ),
    );
  }
}
