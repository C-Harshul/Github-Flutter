import 'package:flutter/material.dart';
import 'data_today.dart';

class Weather extends StatelessWidget {
  final WeatherData weather;

  Weather({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.network(
                  'https://openweathermap.org/img/w/${weather.icon}.png',
                  scale: 0.8,
                ),
                SizedBox(width: 20),
                Text(weather.main,
                    style: TextStyle(color: Colors.white, fontSize: 45)),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${(weather.temp - 273.15).round().toString()}°',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textScaleFactor: 11,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            children: <Widget>[
              SizedBox(height: 80),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  '${(weather.tempMax - 273.15).round().toString()}°',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  '${(weather.tempMin - 273.15).round().toString()}°',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
