import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notesapp/screens/note_list.dart';
import 'package:notesapp/services/notes_service.dart';

void setUpLocator(){
  GetIt.I.registerLazySingleton(() => NotesService());
}

void main() {
  setUpLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notes App",
      home: NoteList(),
    );
  }
}
