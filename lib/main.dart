import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String city = '';
  String temperature = '';
  String description = '';

  TextEditingController _cityController = TextEditingController();

  Future<void> fetchWeather(String cityName) async {
    final apiKey = 'YOUR_API_KEY'; // Replace with your OpenWeatherMap API key
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      setState(() {
        city = decodedData['name'];
        temperature = decodedData['main']['temp'].toString();
        description = decodedData['weather'][0]['description'];
      });
    } else {
      setState(() {
        city = 'Error';
        temperature = '';
        description = 'Error fetching weather data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: 'Enter city name',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                fetchWeather(_cityController.text);
              },
              child: Text('Get Weather'),
            ),
            SizedBox(height: 20),
            Text(
              city,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Temperature: $temperature°C'),
            Text('Weather: $description'),
          ],
        ),
      ),
    );
  }
}
