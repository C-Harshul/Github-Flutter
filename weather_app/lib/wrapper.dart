import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/home_page.dart';


String location;
var _controller = TextEditingController();
String textContent;

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isLoading = false;
  bool checkValue;

  @override
  void initState() {
    super.initState();
    print("initstate");
  }

  void checkLocation() async {
    setState(() {
      isLoading = true;
    });
    location = _controller.text.toLowerCase();
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
      setState(() {
        isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            location: location,
          ),
        ),
      );
    } else {
      print(weatherResponse.statusCode);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Chooser"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  labelText: "Enter the location",
                  border: OutlineInputBorder()),
            ),
            Container(
              child: isLoading
                  ? CircularProgressIndicator(
                      strokeWidth: 3.0,
                      valueColor: new AlwaysStoppedAnimation(Colors.blueAccent),
                    )
                  : null,
            ),
            RaisedButton(
                child: Text("CHECK"),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  print(_controller.text);
                  prefs.setString('location', _controller.text);
                  String data = prefs.getString('location');
                  print("onPressed");
                  print(data);
                  checkLocation();
                }),
          ],
        )),
      ),
    );
  }
}
