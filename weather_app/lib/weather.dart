import 'package:flutter/material.dart';
import 'data_today.dart';

class Weather extends StatelessWidget {
  final WeatherData weather;

  Weather({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(weather.main,
            style: TextStyle(color: Colors.white, fontSize: 24.0)),
        Text('${(weather.temp - 273.15).round().toString()}°C',
            style: TextStyle(color: Colors.white, fontSize: 36)),
        Image.network('https://openweathermap.org/img/w/${weather.icon}.png'),
        //Text( DateFormat.yMMMd().format(weather.date), style: new TextStyle(color: Colors.white)),
        //Text( DateFormat.Hm().format(weather.date), style: new TextStyle(color: Colors.white)),
      ],
    );
  }
}
