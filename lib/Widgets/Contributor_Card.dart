import 'package:flutter/material.dart';


class ContCard extends StatelessWidget {
  final String userName;
  final String dispImg;
  final String followers;
  ContCard({this.followers,this.userName,this.dispImg});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Username: $userName'),
              Text('Followers : $followers')
            ],
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(dispImg),
          ),
        ),
      ),
    );
  }
}