import 'package:flutter/material.dart';
import 'package:weatherapp/wrapper.dart';
import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Wrapper(),);
  }
}
