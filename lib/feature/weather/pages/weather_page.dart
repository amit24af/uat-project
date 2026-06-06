import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService =  WeatherService(dotenv.env['WEATHER_API_KEY'] ?? '');
  Weather? _weather;

  _fetchWeather () async {
    String cityName = await _weatherService.getCurrentCity();
    try{
      final weather = await _weatherService.getWeather(cityName);
      setState((){
        _weather = weather;
      });
    }catch(e){
      print(e);
    }
  }
  String getWeatherAnimation(String? mainCondition){
    if (mainCondition == null) return 'assets/sun.json';
    switch(mainCondition.toLowerCase()){
      case 'smoke':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'partly cloudy':
      case 'clouds':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sun.json';
      case 'snow':
        return 'assets/snow.json';
      default:
        return 'assets/sun.json';
    }
  }

  @override
  void initState(){
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Weather"),
          foregroundColor: Theme
              .of(context)
              .colorScheme
              .tertiary,
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  _weather?.cityName ?? "City..",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                ),
                Text(
                  '${_weather?.temperature.round() ?? '--'}°C',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ]
          ),
        )
    );
  }
}
