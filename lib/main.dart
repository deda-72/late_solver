// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       // home: const MyHomePage(title: 'Flutter Demo Home Page test'),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Row of Labels'),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: Center(
//                 child: RowOfLabels(),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(bottom: 35.0),
//               child: CustomKeyboard(
//                 onKeyPressed: (String key) {
//                   // Handle key press
//                   print('Key pressed: $key');
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RowOfLabels extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(5, (index) {
//         return Container(
//           width: 60.0,
//           height: 60.0,
//           margin: EdgeInsets.all(5.0),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black),
//             color: Colors.white,
//           ),
//           child: Center(
//             child: Text(
//               'L${index + 1}',
//               style: TextStyle(fontSize: 18.0),
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }

// class CustomKeyboard extends StatelessWidget {
//   final Function(String) onKeyPressed;

//   CustomKeyboard({required this.onKeyPressed});

//   final List<List<String>> keys = [
//     ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
//     ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
//     ['Enter', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'Back'],
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: keys.map((row) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 4.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: row.map((key) {
//               // Adjust width for Enter and Back keys
//               double width = (key == 'Enter' || key == 'Back') ? 50.0 : 30.0;
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                 child: SizedBox(
//                   width: width,
//                   height: 40,
//                   child: ElevatedButton(
//                     onPressed: () => onKeyPressed(key),
//                     child: Text(key),
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.zero,
//                       shape: RoundedRectangleBorder(
//                         borderRadius:
//                             BorderRadius.circular(8.0), // Adjust radius here
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page test'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List to hold the selected letters
  List<String> selectedLetters = ['', '', '', '', ''];

  // Index to track the current label position
  int currentLabelIndex = 0;

  void handleKeyPressed(String key) {
    if (currentLabelIndex < 5) {
      setState(() {
        selectedLetters[currentLabelIndex] = key;
        currentLabelIndex++;
      });
    }
  }

  void handleReset() {
    setState(() {
      selectedLetters = ['', '', '', '', ''];
      currentLabelIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Row of Labels'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: RowOfLabels(selectedLetters: selectedLetters),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 35.0),
            child: CustomKeyboard(
              onKeyPressed: handleKeyPressed,
              onResetPressed: handleReset,
            ),
          ),
        ],
      ),
    );
  }
}

class RowOfLabels extends StatelessWidget {
  final List<String> selectedLetters;

  RowOfLabels({required this.selectedLetters});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Container(
          width: 60.0,
          height: 60.0,
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              selectedLetters[index].isEmpty
                  ? 'L${index + 1}'
                  : selectedLetters[index],
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }),
    );
  }
}

class CustomKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onResetPressed;

  CustomKeyboard({required this.onKeyPressed, required this.onResetPressed});

  final List<List<String>> keys = [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Enter', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'Back'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: keys.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((key) {
              // Adjust width for Enter and Back keys
              double width = (key == 'Enter' || key == 'Back') ? 50.0 : 30.0;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: SizedBox(
                  width: width,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      if (key == 'Back') {
                        onResetPressed();
                      } else {
                        onKeyPressed(key);
                      }
                    },
                    child: Text(key),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Adjust radius here
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
