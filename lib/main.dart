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
  List<String> letters = List.generate(5, (_) => '');
  bool isFixed = false;

  void updateLetter(int index, String letter) {
    if (!isFixed) {
      setState(() {
        letters[index] = letter;
      });
    }
  }

  void removeLetter() {
    if (!isFixed) {
      setState(() {
        for (int i = letters.length - 1; i >= 0; i--) {
          if (letters[i].isNotEmpty) {
            letters[i] = '';
            break;
          }
        }
      });
    }
  }

  void submit() {
    if (letters.contains('')) {
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
    print("Letters fixed: ${letters.join()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Letter Row'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  return Container(
                    margin: EdgeInsets.all(4.0),
                    padding: EdgeInsets.all(16.0),
                    color: Colors.blue[100],
                    child: Text(
                      letters[index],
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }),
              ),
            ),
          ),
          Keyboard(
            onLetterSelected: (letter) {
              for (int i = 0; i < letters.length; i++) {
                if (letters[i].isEmpty) {
                  updateLetter(i, letter);
                  break;
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
        double keyWidth =
            (constraints.maxWidth - 25) / 10 * 0.9; // 10 keys per row
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
            style: TextStyle(fontSize: 16),
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
