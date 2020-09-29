//Temperory widget to be used to map the layout of the app

import 'package:flutter/material.dart';
class Place_Holder extends StatelessWidget {
  final double height;
  final double width;
  Place_Holder({@required this.height, @required this.width});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width,
        child: Placeholder(
          fallbackHeight: height,
        ),
      ),
    );
  }
}