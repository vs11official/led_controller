import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const LEDControlApp());
}

class LEDControlApp extends StatelessWidget {
  const LEDControlApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP32 LED Control',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.indigo,
        scaffoldBackgroundColor: Colors.lightBlue,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // Updated text theme
          bodyMedium: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
      ),
      home: const LEDControlHomePage(),
    );
  }
}

class LEDControlHomePage extends StatefulWidget {
  const LEDControlHomePage({Key? key}) : super(key: key);

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
        title: const Text('ESP32C3 LED Control'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _ipController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter ESP32 IP Address',
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    esp32Url = 'http://$value';
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _turnOnLED,
              child: const Text('Turn ON LED'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _turnOffLED,
              child: const Text('Turn OFF LED'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}