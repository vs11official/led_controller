import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const LEDControlApp());
}

class LEDControlApp extends StatelessWidget {
  const LEDControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP32 LED Control',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
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
  const LEDControlHomePage({super.key});

  @override
  _LEDControlHomePageState createState() => _LEDControlHomePageState();
}

class _LEDControlHomePageState extends State<LEDControlHomePage> {
  final TextEditingController _ipController = TextEditingController();
  String? esp32Url;
  bool isLedOn = false;

  // Validate IP address format
  bool isValidIP(String ip) {
    final regex = RegExp(r'^(?:\d{1,3}\.){3}\d{1,3}$');
    return regex.hasMatch(ip);
  }

  // Show feedback to the user
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // Turn ON LED
  Future<void> _turnOnLED() async {
    if (esp32Url != null) {
      try {
        final response = await http.get(Uri.parse('$esp32Url/led/on'));
        if (response.statusCode == 200) {
          _showSnackBar('LED Turned ON');
        } else {
          _showSnackBar('Failed to turn on LED', isError: true);
        }
      } catch (e) {
        _showSnackBar('Error: $e', isError: true);
      }
    } else {
      _showSnackBar('Please enter a valid IP address', isError: true);
    }
  }

  // Turn OFF LED
  Future<void> _turnOffLED() async {
    if (esp32Url != null) {
      try {
        final response = await http.get(Uri.parse('$esp32Url/led/off'));
        if (response.statusCode == 200) {
          _showSnackBar('LED Turned OFF');
        } else {
          _showSnackBar('Failed to turn off LED', isError: true);
        }
      } catch (e) {
        _showSnackBar('Error: $e', isError: true);
      }
    } else {
      _showSnackBar('Please enter a valid IP address', isError: true);
    }
  }

  // Toggle LED
  void _toggleLED() {
    if (isLedOn) {
      _turnOffLED();
    } else {
      _turnOnLED();
    }
    setState(() {
      isLedOn = !isLedOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESP32 LED Control'),
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
                  if (isValidIP(value)) {
                    setState(() {
                      esp32Url = 'http://$value';
                    });
                  } else {
                    esp32Url = null;
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Switch(
              value: isLedOn,
              onChanged: (value) {
                _toggleLED();
              },
            ),
            Text(
              isLedOn ? 'LED is ON' : 'LED is OFF',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}