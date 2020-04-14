import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/wrapper.dart';
import 'home_page.dart';

Future<void> main() async {
  //make Status bar transparent
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var value = prefs.getString('location');
  print("main");
  print(value);
  runApp(
      MaterialApp(home: value == null ? Wrapper() : HomePage(location: value)));
}
