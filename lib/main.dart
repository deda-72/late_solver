import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'wordle_arch.dart'; // Import the wordle_arch.dart file

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DatePickerScreen(),
    );
  }
}

class DatePickerScreen extends StatefulWidget {
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
    final url =
        'https://example.com/path/to/wordlist.txt'; // Replace with your GitHub raw file URL
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
      });
      print('Word for selected date: $word2solve');
    }
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
          print('Word "$currentRowWord" is in the list.');
          // Move to the next row if Enter is pressed and the current row is filled
          if (_currentRow < 5) {
            // Ensure there are more rows to move to
            _currentRow++;
            _currentCol = 0; // Reset to the first column of the next row
          }
        } else {
          print('Word "$currentRowWord" is not in the list.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid WORD')),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Picker Example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Add 6 rows of square widgets
                      for (int i = 0; i < 6; i++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return Container(
                              margin: EdgeInsets.all(
                                  2.0), // Reduced margin for better spacing
                              width: 40.0, // Reduced width of each square
                              height: 40.0, // Reduced height of each square
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black), // Black border
                              ),
                              child: Center(
                                child: Text(
                                  _letters[i][index] ??
                                      '', // Display the letter if present
                                  style: TextStyle(
                                      fontSize: 16), // Reduced font size
                                ),
                              ),
                            );
                          }),
                        ),
                      SizedBox(
                          height: 20), // Space between the rows and the button
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text(
                          '${_selectedDate.toLocal().toString().split(' ')[0]}', // Display date on button
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
          ),
          // QWERTY Keyboard at the bottom
          Container(
            color: Colors.grey[200], // Background color for the keyboard
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                // QWERTY rows
                Container(
                  alignment: Alignment.center,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 2.0, // Reduced spacing between keys
                    runSpacing: 2.0, // Reduced spacing between rows
                    children: List.generate(10, (index) {
                      String letter = '';
                      if (index < 10)
                        letter = 'QWERTYUIOP'.substring(index, index + 1);
                      return GestureDetector(
                        onTap: () => _handleKeyPress(letter),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          width: 30.0, // Reduced width of each key
                          height: 30.0, // Reduced height of each key
                          child: Text(
                            letter,
                            style: TextStyle(fontSize: 14), // Reduced font size
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 2.0, // Reduced spacing between keys
                    runSpacing: 2.0, // Reduced spacing between rows
                    children: List.generate(9, (index) {
                      String letter = '';
                      if (index < 9)
                        letter = 'ASDFGHJKL'.substring(index, index + 1);
                      return GestureDetector(
                        onTap: () => _handleKeyPress(letter),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          width: 30.0, // Reduced width of each key
                          height: 30.0, // Reduced height of each key
                          child: Text(
                            letter,
                            style: TextStyle(fontSize: 14), // Reduced font size
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 2.0, // Reduced spacing between keys
                    runSpacing: 2.0, // Reduced spacing between rows
                    children: List.generate(7, (index) {
                      String letter = '';
                      if (index < 7)
                        letter = 'ZXCVBNM'.substring(index, index + 1);
                      return GestureDetector(
                        onTap: () => _handleKeyPress(letter),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          width: 30.0, // Reduced width of each key
                          height: 30.0, // Reduced height of each key
                          child: Text(
                            letter,
                            style: TextStyle(fontSize: 14), // Reduced font size
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Backspace button
                    GestureDetector(
                      onTap: _handleBackspace,
                      child: Container(
                        margin: EdgeInsets.all(4.0),
                        width: 40.0, // Reduced width of the Backspace button
                        height: 40.0, // Reduced height of the Backspace button
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: Text(
                          '⌫', // Backspace icon
                          style: TextStyle(fontSize: 20), // Adjust font size
                        ),
                      ),
                    ),
                    SizedBox(
                        width: 8.0), // Space between Backspace and Enter button
                    // Enter button
                    GestureDetector(
                      onTap: _handleEnter,
                      child: Container(
                        margin: EdgeInsets.all(4.0),
                        width: 80.0, // Reduced width of the Enter button
                        height: 40.0, // Reduced height of the Enter button
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: Text(
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
