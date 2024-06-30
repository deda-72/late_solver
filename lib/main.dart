import 'package:flutter/material.dart';
import 'word_processor.dart'; // Import the file containing fetchAndProcessWords

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LetterRowScreen(),
    );
  }
}

class LetterRowScreen extends StatefulWidget {
  const LetterRowScreen({super.key});

  @override
  _LetterRowScreenState createState() => _LetterRowScreenState();
}

class _LetterRowScreenState extends State<LetterRowScreen> {
  List<List<String>> rows =
      List.generate(6, (_) => List.generate(5, (_) => ''));
  int currentRow = 0;
  bool isFixed = false;
  DateTime? selectedDate;
  List<String>? upperCaseWords; // List to store the fetched words

  @override
  void initState() {
    super.initState();
    fetchWords(); // Fetch words when the widget is initialized
  }

  void fetchWords() async {
    List<String> words = await fetchAndProcessWords();
    setState(() {
      upperCaseWords = words;
    });
  }

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
      return;
    }

    onEnterPressed();
  }

  void onEnterPressed() {
    final currentWord = rows[currentRow].join();

    if (currentWord.length < 5 ||
        (upperCaseWords != null && !upperCaseWords!.contains(currentWord))) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Invalid Word"),
            content: const Text("Not a valid word"),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      isFixed = true; // Only fix the row if the word is valid
      print("Row ${currentRow + 1} fixed: $currentWord");
      if (currentRow < rows.length - 1) {
        currentRow++;
        isFixed = false; // Reset the fixed state for the next row
      }
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WORDLE Late Solver'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => selectDate(context),
            child: Text(
              selectedDate == null
                  ? 'Select date'
                  : '${selectedDate!.toLocal()}'.split(' ')[0],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: rows.length,
              itemBuilder: (context, rowIndex) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (colIndex) {
                      return Container(
                        width: 55.0,
                        height: 55.0,
                        margin: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            rows[rowIndex][colIndex],
                            style: const TextStyle(fontSize: 24),
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
    super.key,
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
        double keyWidth = (constraints.maxWidth - 20) / 10 * 0.9;
        double keyHeight = 40.0;

        return Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.symmetric(vertical: 10.0),
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
              }),
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
        margin: const EdgeInsets.all(1.0),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: const [
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
            style: const TextStyle(fontSize: 20),
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
        margin: const EdgeInsets.all(1.0),
        width: width * 1.5,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: const [
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
                  style: const TextStyle(fontSize: 20),
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
