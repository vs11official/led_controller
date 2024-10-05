import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(LEDControlApp());
}

class LEDControlApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP32 LED Control',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LEDControlHomePage(),
    );
  }
}

class LEDControlHomePage extends StatefulWidget {
  @override
  _LEDControlHomePageState createState() => _LEDControlHomePageState();
}

class _LEDControlHomePageState extends State<LEDControlHomePage> {
  final TextEditingController _ipController = TextEditingController();
  String? esp32Url;

  Future<void> _turnOnLED() async {
    if (esp32Url != null) {
      final response = await http.get(Uri.parse('$esp32Url/led/on'));
      if (response.statusCode == 200) {
        print('LED Turned ON');
      } else {
        print('Failed to turn on LED');
      }
    } else {
      print('Please enter the IP address first.');
    }
  }

  Future<void> _turnOffLED() async {
    if (esp32Url != null) {
      final response = await http.get(Uri.parse('$esp32Url/led/off'));
      if (response.statusCode == 200) {
        print('LED Turned OFF');
      } else {
        print('Failed to turn off LED');
      }
    } else {
      print('Please enter the IP address first.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ESP32C3 LED Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _ipController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter ESP32 IP Address',
                ),
                onChanged: (value) {
                  setState(() {
                    esp32Url = 'http://$value'; // Set the entered IP address
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _turnOnLED,
              child: Text('Turn ON LED'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _turnOffLED,
              child: Text('Turn OFF LED'),
            ),
          ],
        ),
      ),
    );
  }
}