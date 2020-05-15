import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/wrapper.dart';
import 'data_forecast.dart';
import 'data_today.dart';
import 'info_card.dart';

removeSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("location");
}

class InfoPage extends StatefulWidget {
  final String location;

  InfoPage({Key key, this.location}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> with AutomaticKeepAliveClientMixin<InfoPage> {
  bool _isThereInternet = true;
  bool _isLoading = false;
  WeatherData weatherData;
  ForecastData forecastData;
  String location;
  String error;
  var offlineWeatherData;
  var offlineForecastData;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFileForToday async {
    final path = await _localPath;
    return File('$path/data_today.txt');
  }

  Future writeWeatherToday(String data) async {
    final file = await _localFileForToday;
    return file.writeAsString('$data');
  }

  Future readWeatherToday() async {
    final file = await _localFileForToday;
    String contents = await file.readAsString().then((value) {
      offlineWeatherData = WeatherData.fromJson(jsonDecode(value));
      return value;
    });
    return contents;
  }

  Future<File> get _localFileForForecast async {
    final path = await _localPath;
    return File('$path/data_forecast.txt');
  }

  Future<File> writeWeatherForecast(String data) async {
    final file = await _localFileForForecast;
    return file.writeAsString('$data');
  }

  Future readWeatherForecast() async {
    final file = await _localFileForForecast;
    String contents = await file.readAsString().then((value) {
      offlineForecastData = ForecastData.fromJson(jsonDecode(value));
      return value;
    });
    return contents;
  }

  Future _checkInternetConnectivity() async {
    setState(() {
      _isLoading = true;
    });
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none)
      return false;
    else if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) return true;
  }

  @override
  void initState() {
    location = widget.location;
    _checkInternetConnectivity().then((value) {
      setState(() {
        _isThereInternet = value;
        if (_isThereInternet == true)
          loadWeather().then((value) {
            setState(() {
              _isLoading = false;
            });
          });
        else {
          setState(() {
            readWeatherToday();
            readWeatherForecast();
            _isLoading = false;
          });
        }
      });
    });

    super.initState();
  }

  loadWeather() async {
    setState(() {
      _isLoading = true;
    });

    final weatherResponse = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?q=' + location + '&appid=a9d7c754be7915021a9c4c79b0da6366');
    final forecastResponse = await http.get(
        'https://api.openweathermap.org/data/2.5/forecast?q=' + location + '&appid=a9d7c754be7915021a9c4c79b0da6366');

    if (weatherResponse.statusCode == 200 && forecastResponse.statusCode == 200) {
      writeWeatherToday(weatherResponse.body);
      weatherData = WeatherData.fromJson(jsonDecode(weatherResponse.body));
      writeWeatherForecast(forecastResponse.body);
      forecastData = ForecastData.fromJson(jsonDecode(forecastResponse.body));
      readWeatherToday();
      readWeatherForecast();
      setState(() {
        _isLoading = false;
      });
    }

    setState(() {
      _isLoading = false;
    });

    print(location);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _isThereInternet
            ? Center(
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
                              ? ((weatherData.feelsLike) - 273.15).round().toString() + '°'
                              : '',
                        ),
                        InfoCard(
                          cardName: "Wind",
                          cardValue: weatherData != null ? weatherData.wind.round().toString() + " km/h" : 'km/h',
                        ),
                        InfoCard(
                            cardName: "Humidity",
                            cardValue: weatherData != null ? weatherData.humidity.toString() + "%" : "%")
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  child: Text("Reset"),
                  onPressed: () {
                    removeSharedPreferences();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Wrapper()),
                    );
                  },
                )
              ],
            ),
          ),
        )
            : Center(
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
                          cardValue: offlineWeatherData != null
                              ? ((offlineWeatherData.feelsLike) - 273.15).round().toString() + '°'
                              : '',
                        ),
                        InfoCard(
                          cardName: "Wind",
                          cardValue: offlineWeatherData != null ? offlineWeatherData.wind.round().toString() + " km/h" : 'km/h',
                        ),
                        InfoCard(
                            cardName: "Humidity",
                            cardValue: offlineWeatherData != null ? offlineWeatherData.humidity.toString() + "%" : "%")
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  child: Text("Reset"),
                  onPressed: () {
                    removeSharedPreferences();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Wrapper()),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
