import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<List<String>>> fetchAndProcessCSV() async {
  final url =
      'https://raw.githubusercontent.com/deda-72/WORDLE-archive/main/wordle_archive.csv';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final lines = const LineSplitter().convert(response.body);
    return lines.map((line) => line.split(',')).toList();
  } else {
    throw Exception('Failed to load CSV data');
  }
}
