import 'package:flutter/material.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  String _date;
  String _time;

  Future _pickDate() async {
    DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime.now().add(Duration(days: 1095)));

    if (_date != null)
      setState(() {
        _date = dateTime.toString();
      });
  }

  Future _pickTime() async {
    TimeOfDay timeOfDay =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (_time != null)
      setState(() {
        _time = timeOfDay.toString();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Text(
              "Add new event",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          SizedBox(height: 15),
          TextField(
            autofocus: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                labelText: "Enter event"),
          ),
          SizedBox(height: 15),
          TextField(
            autofocus: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                labelText: "Enter description"),
          ),
          SizedBox(height: 15),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.calendar_today,color: Theme.of(context).accentColor,),
                onPressed: _pickDate,
              ),
              Text("Pick date")
            ],
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.access_time,color: Theme.of(context).accentColor),
                onPressed: _pickTime,
              ),
              Text("Pick time")
            ],
          ),
          SizedBox(height: 15),
          Align(
            alignment: Alignment.centerRight,
            child: FlatButton(
              child: Text("Add"),
              textColor: Theme.of(context).accentColor,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
    );
  }
}
