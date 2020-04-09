import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weatherapp/weather.dart';
import 'data_forecast.dart';
import 'data_today.dart';
import 'info_card.dart';

class InfoPage extends StatefulWidget {
  final String location;

  InfoPage({Key key, this.location}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  bool isLoading = false;
  WeatherData weatherData;
  ForecastData forecastData;
  String location;
  String error;

  @override
  void initState() {
    location = widget.location;
    super.initState();
    loadWeather();
  }

  loadWeather() async {
    setState(() {
      isLoading = true;
    });

    print(location);
    final weatherResponse = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?q=' +
            location +
            '&appid=a9d7c754be7915021a9c4c79b0da6366');
    final forecastResponse = await http.get(
        'https://api.openweathermap.org/data/2.5/forecast?q=' +
            location +
            '&appid=a9d7c754be7915021a9c4c79b0da6366');

    if (weatherResponse.statusCode == 200 &&
        forecastResponse.statusCode == 200) {
      return setState(() {
        weatherData = WeatherData.fromJson(jsonDecode(weatherResponse.body));
        forecastData = ForecastData.fromJson(jsonDecode(forecastResponse.body));
        isLoading = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.6, 1],
                  colors: [Colors.indigoAccent, Colors.purple])),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "DETAILS",
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        height: 2,
                        width: MediaQuery.of(context).size.width * 0.6,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
                Container(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[

                          InfoCard(cardName: "Feels Like",cardValue: weatherData!= null ? ((weatherData.feelsLike) - 273.15).round().toString()  + '°': '',),
                          InfoCard(cardName: "Wind",cardValue: weatherData != null ? weatherData.wind.round().toString() + " km/h" : 'km/h',),
                          InfoCard(cardName: "Humidity", cardValue: weatherData != null ?  weatherData.humidity.toString() + "%" : "%")
                        ],
                      )),

              ],
            ),

        ),
      ),
    );
  }
}
