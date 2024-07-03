import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

Future<List<Map<String, dynamic>>> fetchCsvData() async {
  const String csvUrl =
      'https://raw.githubusercontent.com/deda-72/WORDLE-archive/main/wordle_archive.csv';
  final response = await http.get(Uri.parse(csvUrl));

  if (response.statusCode == 200) {
    final List<List<dynamic>> csvData =
        const CsvToListConverter().convert(response.body);
    final List<Map<String, dynamic>> dataList = [];
    final DateFormat dateFormat =
        DateFormat('M/d/yyyy'); // Adjust the format to match your date format

    for (var row in csvData.skip(1)) {
      // Skip header row
      DateTime date = dateFormat.parse(row[0]);
      String word = row[1];
      dataList.add({'Date': date, 'Word': word});
    }

    return dataList;
  } else {
    throw Exception('Failed to load CSV file');
  }
}

Future<DateTime> getLatestDate() async {
  final data = await fetchCsvData();
  final dates = data.map((e) => e['Date'] as DateTime).toList();
  dates.sort();
  return dates.last;
}

Future<String?> getWordForDate(DateTime date) async {
  final data = await fetchCsvData();
  final entry = data.firstWhere(
    (element) => element['Date'] == date,
    orElse: () => <String, dynamic>{}, // Return an empty map instead of null
  );
  return entry.isNotEmpty ? entry['Word'] as String? : null;
}

Future<List<DateTime>> getActiveDates() async {
  final data = await fetchCsvData();
  return data.map((e) => e['Date'] as DateTime).toList();
}
