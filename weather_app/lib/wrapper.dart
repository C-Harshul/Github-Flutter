import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/home_page.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  String location;
  var _controller = TextEditingController();

//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//  }

  void checkLocation() async{
    location = _controller.text.toLowerCase();
    final weatherResponse = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?q=' + location +'&appid=a9d7c754be7915021a9c4c79b0da6366');
    final forecastResponse = await http.get(
        'https://api.openweathermap.org/data/2.5/forecast?q=' + location + '&appid=a9d7c754be7915021a9c4c79b0da6366');


    if (weatherResponse.statusCode == 200 &&
        forecastResponse.statusCode == 200){
      print(weatherResponse.statusCode);
      print(forecastResponse.statusCode);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(location: location,)));
    }
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
                decoration: InputDecoration(helperText: "Enter the location",
                border: OutlineInputBorder()),
              ),
              RaisedButton(
                child: Text("CHECK"),
                onPressed: checkLocation,
              )
            ],
          )
        ),
      ),
    );
  }
}
