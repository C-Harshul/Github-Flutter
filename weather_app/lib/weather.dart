import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data_today.dart';

class Weather extends StatelessWidget {
  final WeatherData weather;

  Weather({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Image.network(
              'https://openweathermap.org/img/w/${weather.icon}.png',
              scale: 0.8,
            ),
            SizedBox(width: 20),
            AutoSizeText(weather.main,
                style: TextStyle(color: Colors.white, fontSize: 40)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Align(
              child: Text(
                '${(weather.temp - 273.15).round().toString()}°',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textScaleFactor: 11,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      '${(weather.tempMax - 273.15).round().toString()}°',
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 30),
                    ),
                  ),
                  SizedBox(
                    child: Container(color: Colors.white.withOpacity(0.5)),
                    height: 1,
                    width: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      '${(weather.tempMin - 273.15).round().toString()}°',
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 30),
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
