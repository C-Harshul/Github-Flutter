import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notesapp/models/note.dart';
import 'package:notesapp/models/note_manipulate.dart';
import 'package:notesapp/services/database_helper.dart';
import 'package:notesapp/services/notes_service.dart';

import 'note_list.dart';

class NoteModify extends StatefulWidget {
  final String noteID;
  bool isThereInternet;

  NoteModify({this.noteID, @required this.isThereInternet});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID != null;

  bool get _isThereInternet => widget.isThereInternet;

  NotesService get notesService => GetIt.I<NotesService>();

  String errorMessage;
  Note note;
  var offlineJsonData;

  DatabaseHelper _databaseHelper = DatabaseHelper();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (_isThereInternet == true) {
      if (isEditing) {
        setState(() {
          _isLoading = true;
        });
        notesService.getNote(widget.noteID).then((response) {
          setState(() {
            _isLoading = false;
          });
          if (response.error) {
            errorMessage = response.errorMessage ?? 'An error occurred';
          }
          note = response.data;
          _titleController.text = note.noteTitle;
          _contentController.text = note.noteContent;
        });
      }
    } else {
      if (isEditing) {
        setState(() {
          _isLoading = true;
        });
        _databaseHelper.getNote(widget.noteID).then((value) {
          offlineJsonData = jsonDecode(value)[0];
          _titleController.text = offlineJsonData['noteTitle'];
          _contentController.text = offlineJsonData['noteContent'];
          setState(() {
            _isLoading = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text(isEditing ? 'Edit note' : 'Create note'),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: () async {
                      if (_isThereInternet == true) {
                        if (isEditing) {
                          setState(() {
                            _isLoading = true;
                          });
                          final note =
                              NoteManipulate(noteTitle: _titleController.text, noteContent: _contentController.text);
                          final result = await notesService.updateNote(widget.noteID, note);
                          setState(() {
                            _isLoading = false;
                          });
                          final title = 'Done';
                          final text =
                              result.error ? (result.errorMessage ?? 'An error occurred') : 'Your note was updated';
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text(title),
                                    content: Text(text),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  )).then((data) {
                            if (result.data) {
                              Navigator.of(context).pop();
                            }
                          });
                        } else {
                          setState(() {
                            _isLoading = true;
                          });
                          final note =
                              NoteManipulate(noteTitle: _titleController.text, noteContent: _contentController.text);
                          final result = await notesService.createNote(note);
                          setState(() {
                            _isLoading = false;
                          });
                          final title = 'Done';
                          final text =
                              result.error ? (result.errorMessage ?? 'An error occurred') : 'Your note was created';
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text(title),
                                    content: Text(text),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  )).then((data) {
                            if (result.data) {
                              Navigator.of(context).pop();
                            }
                          });
                        }
                      } else {
                        if (isEditing) {
                          setState(() {
                            _isLoading = true;
                          });
                          Note note = Note(
                              noteID: widget.noteID,
                              noteTitle: _titleController.text,
                              noteContent: _contentController.text,
                              lastEditedDateTime: DateTime.now());
                          _databaseHelper.updateNote(note).then((value) {
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NoteList()));
                          });
                        } else {
                          setState(() {
                            _isLoading = true;
                          });
                          Note newNote = Note(
                              noteID: DateTime.now().toString(),
                              noteTitle: _titleController.text,
                              noteContent: _contentController.text,
                              createdDateTime: DateTime.now());
                          print("at save note");
                          _databaseHelper.saveNote(newNote).then((value) {
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NoteList()));
                          });
                        }
                      }
                    },
                    child: Icon(Icons.done),
                  ),
                )
              ],
            ),
            body: _isThereInternet == true
                ? Padding(
                    padding: EdgeInsets.all(30),
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 20),
                                TextField(
                                  controller: _titleController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(hintText: "Note title", border: InputBorder.none),
                                ),
                                SizedBox(height: 18),
                                TextField(
                                  controller: _contentController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  style: TextStyle(fontSize: 20),
                                  decoration: InputDecoration(hintText: "Note content", border: InputBorder.none),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                  )
                : Padding(
                    padding: EdgeInsets.all(30),
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 20),
                                TextField(
                                  autofocus: true,
                                  controller: _titleController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(hintText: "Note title", border: InputBorder.none),
                                ),
                                SizedBox(height: 18),
                                TextField(
                                  controller: _contentController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  style: TextStyle(fontSize: 20),
                                  decoration: InputDecoration(hintText: "Note content", border: InputBorder.none),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                  ),
          );
  }
}
