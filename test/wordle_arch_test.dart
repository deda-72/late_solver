import 'package:flutter_test/flutter_test.dart';
import 'package:late_solver/wordle_arch.dart'; // Replace with your actual import
import 'dart:async';

void main() {
  test('fetchAndProcessCSV prints the CSV content', () async {
    // Capture the output
    final printLog = <String>[];
    void logPrint(String message) => printLog.add(message);

    // Override print method
    var spec = ZoneSpecification(
      print: (self, parent, zone, message) {
        logPrint(message);
      },
    );

    await Zone.current.fork(specification: spec).run(() async {
      List<List<String>> words = await fetchAndProcessCSV();

      // Print the fetched words
      for (var wordPair in words) {
        print('Word Pair: ${wordPair[0]}, ${wordPair[1]}');
      }
    });

    // Check the captured output
    for (var log in printLog) {
      print(log); // Print captured logs
    }

    // Optionally, you can add assertions to validate the data
    expect(printLog, isNotEmpty);
    expect(printLog.first.contains('Word Pair'), isTrue);
  });
}
