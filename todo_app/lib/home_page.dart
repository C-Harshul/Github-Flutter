import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/add_task_page.dart';
import 'package:todoapp/task_page.dart';

import 'add_event_page.dart';
import 'event_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static var now = new DateTime.now();
  String today = "dfds";
  bool button = true;

  @override
  void initState() {
    super.initState();
    if (now.weekday == 1) today = "Monday";
    if (now.weekday == 2) today = "Tuesday";
    if (now.weekday == 3) today = "Wednesday";
    if (now.weekday == 4) today = "Thursday";
    if (now.weekday == 5) today = "Friday";
    if (now.weekday == 6) today = "Saturday";
    if (now.weekday == 7) today = "Sunday";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("To Do List")),
      body: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).accentColor,
            height: 35,
          ),
          _mainContent(context),
          Positioned(
            right: 10,
            child: Text(
              now.day.toString(),
              style: TextStyle(fontSize: 200, color: Color(0x10000000)),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: button == true ? AddTaskPage() : AddEventPage(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  );
                });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            ),
            IconButton(icon: Icon(Icons.more_vert))
          ],
        ),
      ),
    );
  }

  Widget _mainContent(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Theme.of(context).accentColor,
        ),
        SizedBox(height: 60),
        Container(
          padding: EdgeInsets.all(20),
          child: Text(
            today,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 40),
        Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  child: Text("Tasks"),
                  color: button == true
                      ? Theme.of(context).accentColor
                      : Colors.white,
                  textColor: button == true
                      ? Colors.white
                      : Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.all(14),
                  onPressed: () {
                    setState(() {
                      button = true;
                    });
                  },
                ),
              ),
              SizedBox(width: 32),
              Expanded(
                child: MaterialButton(
                  child: Text("Events"),
                  color: button == false
                      ? Theme.of(context).accentColor
                      : Colors.white,
                  textColor: button == false
                      ? Colors.white
                      : Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.all(14),
                  onPressed: () {
                    setState(() {
                      button = false;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: button == true
                ? TaskPage(
                    task: "ooo",
                    )
                : EventPage())
      ],
    );
  }
}
