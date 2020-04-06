import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class Event {
  final String time;
  final String task;
  final String desc;
  final bool isFinished;

  Event(this.time, this.task, this.desc, this.isFinished);
}

final List<Event> _eventList = [
  Event("08:00", "Have coffee with Sam", "Personal", true),
  Event("10:00", "Meet with Sales", "Work", true),
  Event("12:00", "Edit API documentation about SSO", "Work", false),
  Event("18:00", "Go to gym", "Personal", false),
];

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    var _accentColor = Theme.of(context).accentColor;
    return ListView.builder(
      itemCount: _eventList.length,
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Row(
              children: <Widget>[
                _eventList[index].isFinished == true ?
                Icon(
                  Icons.fiber_manual_record,
                  size: 20,
                  color: _accentColor,
                ):
                Icon(
                  Icons.radio_button_unchecked,
                  size: 20,
                  color: _accentColor,
                ),
                SizedBox(width: 20),
                Text(_eventList[index].time),
                SizedBox(width: 20),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(_eventList[index].task, style: TextStyle(fontSize: 18),),
                            SizedBox(height: 12),
                            Text(_eventList[index].desc, style: TextStyle(color: Colors.grey),)
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
