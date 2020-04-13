import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:weatherapp/wrapper.dart';
import 'data_forecast.dart';
import 'data_today.dart';
import 'info_card.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  print(directory.path);
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/data.txt');
}

Future<String> readContent() async {
  try {
    final file = await _localFile;
    String contents = await file.readAsString();
    print("info page" + contents);
    return contents;
  } catch (e) {
    return 'Error';
  }
}

Future deleteContent() async{
  final file = await _localFile;
  file.delete(recursive: true);
}

class InfoPage extends StatefulWidget {
  final String location;

  InfoPage({Key key, this.location}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage>
    with AutomaticKeepAliveClientMixin<InfoPage> {
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

    print(location);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
        child: Container(
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
                padding: EdgeInsets.all(20),
                child: Container(
                  //padding: EdgeInsets.all(8),
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      InfoCard(
                        cardName: "Feels Like",
                        cardValue: weatherData != null
                            ? ((weatherData.feelsLike) - 273.15)
                                    .round()
                                    .toString() +
                                '°'
                            : '',
                      ),
                      InfoCard(
                        cardName: "Wind",
                        cardValue: weatherData != null
                            ? weatherData.wind.round().toString() + " km/h"
                            : 'km/h',
                      ),
                      InfoCard(
                          cardName: "Humidity",
                          cardValue: weatherData != null
                              ? weatherData.humidity.toString() + "%"
                              : "%")
                    ],
                  ),
                ),
              ),
              RaisedButton(
                child: Text("Reset"),
                onPressed: () {
                  readContent();
                  deleteContent();
                  readContent();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Wrapper()
                    ),
                  );
                },
              )
            ],
          ),
        ),
      )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
