import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/weather.dart';
import 'weather_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'data_today.dart';
import 'data_forecast.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  final String location;

  HomePage({Key key, this.location}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        'https://api.openweathermap.org/data/2.5/weather?q=' + location + '&appid=a9d7c754be7915021a9c4c79b0da6366');
    final forecastResponse = await http.get(
        'https://api.openweathermap.org/data/2.5/forecast?q='+ location +'&appid=a9d7c754be7915021a9c4c79b0da6366');

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

  var appBar = AppBar(
    title: Text("Weather"),
    elevation: 0,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
          backgroundColor: Colors.blue,
          appBar: appBar,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(DateFormat.MMMMd().format(weatherData.date),
                        style: new TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(weatherData.name,
                        textScaleFactor: 3,
                        style: new TextStyle(color: Colors.white)),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: weatherData != null
                                ? Weather(weather: weatherData)
                                : null),
                        Container(
                          child: isLoading
                              ? CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor:
                                      new AlwaysStoppedAnimation(Colors.white),
                                )
                              : IconButton(
                                  icon: new Icon(Icons.refresh),
                                  tooltip: 'Refresh',
                                  onPressed: loadWeather,
                                  color: Colors.white,
                                ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Container(
                        padding: const EdgeInsets.all(8.0),
                        height: 200.0,
                        child: forecastData != null
                            ? ListView.builder(
                                itemCount: 5,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => WeatherCard(
                                    weather:
                                        forecastData.list.elementAt(index * 8)))
                            : null),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
