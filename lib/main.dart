import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'wordle_arch.dart'; // Import the wordle_arch.dart file
import 'get_codes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DatePickerScreen(),
    );
  }
}

class DatePickerScreen extends StatefulWidget {
  const DatePickerScreen({super.key});

  @override
  _DatePickerScreenState createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  DateTime _selectedDate = DateTime.now(); // Initial date
  List<DateTime> _activeDates = [];
  String? word2solve;
  bool _isLoading = true;

  List<List<String?>> _letters = List.generate(
    6,
    (_) => List.generate(5, (_) => null),
  );

  int _currentRow = 0;
  int _currentCol = 0;
  List<String> _wordList = [];
  List<List<Color?>> _colors =
      List.generate(6, (_) => List.generate(5, (_) => Colors.white));

  @override
  void initState() {
    super.initState();
    _initializeDates();
    _loadWordList(); // Load word list on initialization
  }

  Future<void> _initializeDates() async {
    try {
      DateTime latestDate = await getLatestDate();
      List<DateTime> activeDates = await getActiveDates();
      String? initialWord = await getWordForDate(latestDate);
      setState(() {
        _selectedDate = latestDate;
        _activeDates = activeDates;
        word2solve = initialWord;
        _isLoading = false;
      });
      print('Initial word for latest date: $word2solve');
    } catch (e) {
      print('Failed to load date: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadWordList() async {
    const url =
        'https://raw.githubusercontent.com/deda-72/WORDLE-archive/main/Possible_guesses.txt'; // Replace with your GitHub raw file URL
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Process the response body
        setState(() {
          _wordList = response.body
              .split('\n')
              .map((line) =>
                  line.trim().toUpperCase()) // Convert each line to uppercase
              .toList();

          // Print the first 5 words to the debug console
          for (int i = 0; i < 5 && i < _wordList.length; i++) {
            print('Word ${i + 1}: ${_wordList[i]}');
          }
        });
      } else {
        print('Failed to load word list.');
      }
    } catch (e) {
      print('Error fetching word list: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime date) {
        return _activeDates.contains(date);
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      String? word = await getWordForDate(pickedDate);
      setState(() {
        _selectedDate = pickedDate;
        word2solve = word;
        _clearRows(); // Clear all rows when a new date is picked
        _resetColors(); // Reset background colors to white
      });
      print('Word for selected date: $word2solve');
    }
  }

  void _clearRows() {
    setState(() {
      _letters = List.generate(6, (_) => List.generate(5, (_) => null));
      _currentRow = 0;
      _currentCol = 0;
    });
  }

  void _resetColors() {
    setState(() {
      _colors = List.generate(6, (_) => List.generate(5, (_) => Colors.white));
    });
  }

  void _handleKeyPress(String letter) {
    if (_currentRow < 6) {
      setState(() {
        if (_currentCol < 5) {
          _letters[_currentRow][_currentCol] = letter;
          _currentCol++;
        }
      });
    }
  }

  void _handleBackspace() {
    setState(() {
      if (_currentCol > 0) {
        _currentCol--;
        _letters[_currentRow][_currentCol] = null;
      }
    });
  }

  void _handleEnter() {
    setState(() {
      if (_currentCol >= 5) {
        String currentRowWord = _letters[_currentRow].join();
        if (_wordList.contains(currentRowWord)) {
          List<int> codes = generateCodes(currentRowWord, word2solve!);
          debugPrint('Codes for "$currentRowWord" vs "$word2solve": $codes');
          if (codes.every((code) => code == 3)) {
            _updateRowColors(
                _currentRow, codes); // Update row colors based on codes
            _showGoodJobDialog();
          } else {
            _updateRowColors(
                _currentRow, codes); // Update row colors based on codes
            if (_currentRow < 5) {
              _currentRow++;
              _currentCol = 0;
            }
          }
        } else {
          _showAlertDialog('Invalid Word !!!');
        }
      }
    });
  }

  void _showGoodJobDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Good Job"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                _clearRows(); // Clear all rows when "OK" is clicked
                _resetColors();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateRowColors(int rowIndex, List<int> codes) {
    if (rowIndex >= 0 && rowIndex < 6 && codes.length == 5) {
      setState(() {
        _colors[rowIndex] =
            List.generate(5, (index) => _getColorForCode(codes[index]));
      });
    }
  }

  Color _getColorForCode(int code) {
    switch (code) {
      case 3:
        return Colors.green;
      case 1:
        return Colors.grey;
      case 2:
        return Colors.yellow;
      case 0:
        return Colors.grey;
      default:
        return Colors.white;
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date Picker Example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Add 6 rows of square widgets
                      for (int i = 0; i < 6; i++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return Container(
                              margin: const EdgeInsets.all(
                                  2.0), // Reduced margin for better spacing
                              width: 50.0, // Reduced width of each square
                              height: 50.0, // Reduced height of each square
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black), // Black border
                                color: _colors[i]
                                    [index], // Set background color
                              ),
                              child: Center(
                                child: Text(
                                  _letters[i][index] ??
                                      '', // Display the letter if present
                                  style: const TextStyle(
                                      fontSize: 16), // Reduced font size
                                ),
                              ),
                            );
                          }),
                        ),
                      const SizedBox(
                          height: 20), // Space between the rows and the button
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text(
                          _selectedDate
                              .toLocal()
                              .toString()
                              .split(' ')[0], // Display date on button
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
          ),
          // QWERTY Keyboard at the bottom
          Container(
            color: Colors.grey[200], // Background color for the keyboard
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // QWERTY rows
                Container(
                  alignment: Alignment.center,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 2.0, // Reduced spacing between keys
                    runSpacing: 10.0, // Reduced spacing between rows
                    children: List.generate(10, (index) {
                      String letter = '';
                      if (index < 10) {
                        letter = 'QWERTYUIOP'.substring(index, index + 1);
                      }
                      return GestureDetector(
                        onTap: () => _handleKeyPress(letter),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          width: 35.0, // Reduced width of each key
                          height: 35.0, // Reduced height of each key
                          child: Text(
                            letter,
                            style: const TextStyle(
                                fontSize: 14), // Reduced font size
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 4.0), // Space between rows
                Container(
                  alignment: Alignment.center,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 2.0, // Reduced spacing between keys
                    runSpacing: 10.0, // Reduced spacing between rows
                    children: List.generate(9, (index) {
                      String letter = '';
                      if (index < 9) {
                        letter = 'ASDFGHJKL'.substring(index, index + 1);
                      }
                      return GestureDetector(
                        onTap: () => _handleKeyPress(letter),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          width: 35.0, // Reduced width of each key
                          height: 35.0, // Reduced height of each key
                          child: Text(
                            letter,
                            style: const TextStyle(
                                fontSize: 14), // Reduced font size
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 4.0), // Space between rows
                Container(
                  alignment: Alignment.center,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 2.0, // Reduced spacing between keys
                    runSpacing: 10.0, // Reduced spacing between rows
                    children: List.generate(7, (index) {
                      String letter = '';
                      if (index < 7) {
                        letter = 'ZXCVBNM'.substring(index, index + 1);
                      }
                      return GestureDetector(
                        onTap: () => _handleKeyPress(letter),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          width: 35.0, // Reduced width of each key
                          height: 35.0, // Reduced height of each key
                          child: Text(
                            letter,
                            style: const TextStyle(
                                fontSize: 14), // Reduced font size
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 8.0), // Space between rows
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Backspace button
                    GestureDetector(
                      onTap: _handleBackspace,
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        width: 40.0, // Reduced width of the Backspace button
                        height: 40.0, // Reduced height of the Backspace button
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: const Text(
                          '⌫', // Backspace icon
                          style: TextStyle(fontSize: 20), // Adjust font size
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 8.0), // Space between Backspace and Enter button
                    // Enter button
                    GestureDetector(
                      onTap: _handleEnter,
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        width: 80.0, // Reduced width of the Enter button
                        height: 40.0, // Reduced height of the Enter button
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: const Text(
                          'Enter', // Enter text
                          style: TextStyle(fontSize: 16), // Reduced font size
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
