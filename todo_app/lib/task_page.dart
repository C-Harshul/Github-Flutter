import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
  String task;

  TaskPage({Key key, this.task}) : super(key: key);
}

class Task {
  final String task;
  final int isFinished;

  Task(this.task, this.isFinished);
}

List<Task> taskList = [
  Task("Call Tom about appointment", 0),
  Task("Fix on boarding experience", 0),
  Task("Edit API documentation", 0),
  Task("Set up user focus group", 0),
  Task("Have Coffee with Sam", 1),
  Task("Meet with Sales", 1)
];

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    super.initState();
    taskList.add(Task(widget.task, 0));
    taskList.sort((a, b) => a.isFinished.compareTo(b.isFinished));
  }

  Widget _taskIncomplete(String task) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.radio_button_unchecked,
                color: Theme
                    .of(context)
                    .accentColor, size: 20),
            onPressed: () {},
          ),
          SizedBox(width: 18),
          Text(task)
        ],
      ),
    );
  }

  Widget _taskComplete(String task) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.radio_button_checked,
                color: Theme
                    .of(context)
                    .accentColor, size: 20),
          ),
          SizedBox(width: 18),
          Text(
            task,
            style: TextStyle(fontWeight: FontWeight.w200),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          return taskList[index].isFinished == 1
              ? _taskComplete(taskList[index].task)
              : _taskIncomplete(taskList[index].task);
        });
  }
}
