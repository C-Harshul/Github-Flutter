import 'package:flutter/material.dart';
import 'data_today.dart';

class Weather extends StatelessWidget {
  final WeatherData weather;

  Weather({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(weather.main, style: TextStyle(color: Colors.white, fontSize: 24)),
        SizedBox(height: 20),
        Image.network('https://openweathermap.org/img/w/${weather.icon}.png'),
        SizedBox(height: 20),
        Text(
          '${(weather.temp - 273.15).round().toString()}°C',
          style: TextStyle(color: Colors.white),
          textScaleFactor: 5,
        ),
      ],
    );
  }
}
