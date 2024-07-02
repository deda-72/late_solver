import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeDates();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Picker Example'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  '${_selectedDate.toLocal().toString().split(' ')[0]}', // Display date on button
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
    );
  }
}
