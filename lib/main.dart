import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> labels = ['', '', '', '', ''];
  TextEditingController _controller = TextEditingController();

  void updateLabels(String text) {
    setState(() {
      for (int i = 0; i < labels.length; i++) {
        if (i < text.length) {
          labels[i] = text[i];
        } else {
          labels[i] = '';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Keyboard and Labels Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Text(labels[index]),
                );
              }),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              maxLength: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter text',
              ),
              onChanged: (text) {
                updateLabels(text);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  labels = ['', '', '', '', ''];
                  _controller.clear();
                });
              },
              child: Text('Clear'),
            ),
          ],
        ),
      ),
    );
  }
}
