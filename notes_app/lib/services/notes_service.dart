import 'dart:convert';

import 'package:notesapp/models/api_response.dart';
import 'package:notesapp/models/note.dart';
import 'package:notesapp/models/note_for_listing.dart';
import 'package:notesapp/models/note_manipulate.dart';
import 'package:notesapp/screens/note_list.dart';
import 'package:http/http.dart' as http;
import 'package:notesapp/services/database_helper.dart';

class NotesService {
  static const APIURL = 'http://api.notes.programmingaddict.com';
  static const headers = {'apiKey': '275c2b89-07b0-46b3-b7af-cf9f1c5c63cc', 'Content-type': 'application/json'};

  DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<APIResponse<List<NoteForListing>>> getNotesList() {
    return http.get(APIURL + '/notes', headers: headers).then((data) {
      if (data.statusCode == 200) {
        var jsonData = json.decode(data.body);
        int onlineLength = jsonData.length;
        int offlineLength = 0;
        _databaseHelper.getNoteMapList().then((value) {
          offlineLength = value.length;
        });
        print(offlineLength);
        final notes = <NoteForListing>[];
        for (var item in jsonData) {
          notes.add(NoteForListing.fromJson(item));
          getNote(NoteForListing.fromJson(item).noteID).then((value) {
            _databaseHelper.saveNote(value.data);
          });
        }
        return APIResponse<List<NoteForListing>>(data: notes);
      }
      return APIResponse<List<NoteForListing>>(error: true, errorMessage: 'Error is ' + data.statusCode.toString());
    }).catchError((_) => APIResponse<List<NoteForListing>>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<Note>> getNote(String noteID) {
    return http.get(APIURL + '/notes/' + noteID, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Note>(data: Note.fromJson(jsonData));
      }
      return APIResponse<Note>(error: true, errorMessage: 'Error is ' + data.statusCode.toString());
    }).catchError((_) => APIResponse<Note>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<bool>> createNote(NoteManipulate item) {
    return http.post(APIURL + '/notes', headers: headers, body: jsonEncode(item.toJson())).then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'Error is ' + data.statusCode.toString());
    }).catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<bool>> updateNote(String noteID, NoteManipulate item) {
    return http.put(APIURL + '/notes/' + noteID, headers: headers, body: jsonEncode(item.toJson())).then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'Error is ' + data.statusCode.toString());
    }).catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<bool>> deleteNote(String noteID) {
    return http.delete(APIURL + '/notes/' + noteID, headers: headers).then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'Error is ' + data.statusCode.toString());
    }).catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }
}
