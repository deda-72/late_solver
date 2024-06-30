// lib/word_processor.dart
import 'package:http/http.dart' as http;

Future<List<String>> fetchAndProcessWords() async {
  const url =
      'https://raw.githubusercontent.com/deda-72/WORDLE-archive/main/Possible_guesses.txt';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final content = response.body;
      final lines = content.split('\n');
      final upperCaseWords = lines
          .where((line) => line.isNotEmpty)
          .map((line) => line.trim().toUpperCase())
          .toList();

      return upperCaseWords;
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('An error occurred: $e');
    return [];
  }
}
