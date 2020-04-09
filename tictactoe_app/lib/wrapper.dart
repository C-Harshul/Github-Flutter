import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tictactoeapp/single_player_page.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.purple,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 200,
          ),
          Align(
            child: Container(
              child: Text(
                "TIC TAC TOE ",
                style: TextStyle(fontSize: 40, color: Colors.greenAccent),
              ),
            ),
            alignment: Alignment(0, 0),
          ),
          SizedBox(
            height: 200,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: FlatButton(
                  color: Colors.greenAccent,
                  child: Text("Single Player"),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/singleplayer'),
                ),
                padding: EdgeInsets.all(20),
              ),
              Container(
                child: FlatButton(
                  color: Colors.greenAccent,
                  child: Text("Double Player"),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/doubleplayer'),
                ),
                padding: EdgeInsets.all(20),
              )
            ],
          )
        ],
      ),
    ));
  }
}
