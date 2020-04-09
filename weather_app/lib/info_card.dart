import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InfoCard extends StatelessWidget {
  String cardName, cardValue;

  InfoCard({Key key, this.cardName, this.cardValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      //elevation: 0,
      child: Container(
        height: 100,
        width: 100,
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(cardName ?? '',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8), fontSize: 12)),
            Text(cardValue ?? '',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
