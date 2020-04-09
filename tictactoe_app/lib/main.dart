import 'package:flutter/material.dart';
import 'package:tictactoeapp/wrapper.dart';
import 'double_player_page.dart';
import 'single_player_page.dart';

void main () => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/': (context) => Wrapper(),
        '/singleplayer': (context) => SinglePlayerPage(),
        '/doubleplayer': (context) => DoublePlayerPage(),
      },
    );
  }
}
