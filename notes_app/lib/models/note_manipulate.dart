import 'package:flutter/cupertino.dart';

class NoteManipulate {
  String noteTitle;
  String noteContent;

  NoteManipulate({@required this.noteTitle, @required this.noteContent});

  Map<String, dynamic> toJson() {
    return {"noteTitle": noteTitle, "noteContent": noteContent};
  }
}
