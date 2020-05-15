import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weatherapp/info_page.dart';
import 'package:weatherapp/weather.dart';
import 'weather_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'data_today.dart';
import 'data_forecast.dart';

class HomePage extends StatefulWidget {
  final String location;

  HomePage({Key key, this.location}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {
  PageController _pageController = PageController(initialPage: 0, keepPage: true);

  bool _isLoading = false;
  bool _isThereInternet = true;
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
          Fluttertoast.showToast(
              msg: "You have no internet. Showing old data.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.greenAccent,
              textColor: Colors.black,
              fontSize: 16.0
          );
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
      return setState(() {
        writeWeatherToday(weatherResponse.body);
        weatherData = WeatherData.fromJson(jsonDecode(weatherResponse.body));
        writeWeatherForecast(forecastResponse.body);  
        forecastData = ForecastData.fromJson(jsonDecode(forecastResponse.body));
        readWeatherToday();
        readWeatherForecast();
        setState(() {
          _isLoading = false;
        });
      });
    }

    setState(() {
      _isLoading = false;
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
            body: _isThereInternet
                ? PageView(
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
                                child: Text(weatherData != null ? weatherData.name : widget.location,
                                    textScaleFactor: 3, style: TextStyle(color: Colors.white)),
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text(DateFormat.MMMMd().format(DateTime.now()),
                                        style: TextStyle(color: Colors.white.withOpacity(0.87), fontSize: 24)),
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
                                          child: weatherData != null ? Weather(weather: weatherData) : null),
                                    ),
                                    Container(
                                      child: _isLoading
                                          ? CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              valueColor: AlwaysStoppedAnimation(Colors.white),
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
                                            itemBuilder: (context, index) =>
                                                WeatherCard(weather: forecastData.list.elementAt(index * 8)))
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
                  )
                : PageView(
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
                                child: Text(offlineWeatherData != null ? offlineWeatherData.name : widget.location,
                                    textScaleFactor: 3, style: TextStyle(color: Colors.white)),
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text(DateFormat.MMMMd().format(DateTime.now()),
                                        style: TextStyle(color: Colors.white.withOpacity(0.87), fontSize: 24)),
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
                                          child: offlineWeatherData != null ? Weather(weather: offlineWeatherData) : null),
                                    ),
                                    Container(
                                      child: _isLoading
                                          ? CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              valueColor: AlwaysStoppedAnimation(Colors.white),
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
                                    child: offlineForecastData != null
                                        ? ListView.builder(
                                            itemCount: 5,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) =>
                                                WeatherCard(weather: offlineForecastData.list.elementAt(index * 8)))
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
                  )));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
