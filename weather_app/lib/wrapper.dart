import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:weatherapp/home_page.dart';

String location;

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  print(directory.path);
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/data.txt');
}

Future<File> writeContent() async {
  final file = await _localFile;
  if (location != null) {
    return file.writeAsString('$location');
  } else
    return null;
}

Future<String> readContent() async {
  try {
    final file = await _localFile;
    String contents = await file.readAsString();
    return contents;
  } catch (e) {
    return 'Error';
  }
}

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String data;

  bool isLoading = false;
  var _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    writeContent();
    readContent().then((String value) {
      setState(() {
        data = value;
        if (data != 'Error') {
          _controller.text = data;
          print(_controller.text);
          checkLocation();
        }
      });
    });
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
                onPressed: () {
                  writeContent();
                  checkLocation();
                }),
          ],
        )),
      ),
    );
  }
}
