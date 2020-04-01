import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'data_today.dart';

class WeatherCard extends StatelessWidget {
  final WeatherData weather;

  WeatherCard({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Text(weather.name, style: new TextStyle(color: Colors.white)),
            Text(weather.main,
                style: new TextStyle(color: Colors.white, fontSize: 24.0)),
            Text('${(weather.temp -273.15).round().toString()}°C',
                style: new TextStyle(color: Colors.white)),
            Image.network(
                'https://openweathermap.org/img/w/${weather.icon}.png'),
            Text(new DateFormat.MMMd().format(weather.date),
                style: new TextStyle(color: Colors.white)),
//            Text(new DateFormat.Hm().format(weather.date),
//                style: new TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
