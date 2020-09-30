//Routes file to store all the routes of the app
import 'package:flutter/material.dart';
import 'package:github_flutter/screens/SignIn.dart';
import 'package:github_flutter/screens/Home_Page.dart';
import 'package:github_flutter/screens/Contributors.dart';

Map<String, Widget Function(BuildContext)> routes ={
 SignIn.routeName:(ctx) => SignIn(),
 HomePage.routename:(ctx) => HomePage(),
 Contributors.routename:(ctx) => Contributors(),
};
