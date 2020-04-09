import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/info_page.dart';
import 'package:weatherapp/weather.dart';
import 'weather_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'data_today.dart';
import 'data_forecast.dart';

class HomePage extends StatefulWidget {
  final String location;

  HomePage({Key key, this.location}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

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

    Future.delayed(const Duration(milliseconds: 500), () {
      print("hello");
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
        primarySwatch: Colors.orange,
      ),
      home: Scaffold(
          body: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.6, 1],
                    colors: [Colors.indigoAccent, Colors.purple])),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                        weatherData != null
                            ? weatherData.name
                            : widget.location,
                        textScaleFactor: 3,
                        style: TextStyle(color: Colors.white)),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(DateFormat.MMMMd().format(DateTime.now()),
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.87),
                                fontSize: 24)),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: <Widget>[],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: weatherData != null
                                  ? Weather(weather: weatherData)
                                  : null),
                        ),
                        Container(
                          child: isLoading
                              ? CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : IconButton(
                                  icon: Icon(Icons.refresh),
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
          ),
          InfoPage(
            location: location,
          ),
        ],
      )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
