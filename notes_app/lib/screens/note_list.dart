import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:notesapp/models/api_response.dart';
import 'package:notesapp/models/note_for_listing.dart';
import 'package:notesapp/screens/note_delete.dart';
import 'package:notesapp/services/notes_service.dart';
import 'note_modify.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NotesService get service => GetIt.I<NotesService>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  APIResponse _apiResponse;
  bool _isLoading = false;

  formatDateTime(DateTime dateTime) {
    return DateFormat.yMMMd().format(dateTime);
  }

  Future fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getNotesList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    fetchNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Notes"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => NoteModify()))
                .then((_) => fetchNotes());
          },
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: fetchNotes,
          child: Builder(
            builder: (context) {
              if (_isLoading) return Center(child: CircularProgressIndicator());
              if (_apiResponse.error)
                return Center(child: Text(_apiResponse.errorMessage));
              return Column(children: <Widget>[
                //Expanded(child: Container(color: Colors.blue)),
                Expanded(
                  flex: 5,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: ValueKey(_apiResponse.data[index].noteID),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {},
                        confirmDismiss: (direction) async {
                          final result = await showDialog(
                              context: context,
                              builder: (context) => NoteDelete());
                          if (result) {
                            final deleteResult = await service
                                .deleteNote(_apiResponse.data[index].noteID);
                            var message;
                            if (deleteResult != null &&
                                deleteResult.data == true) {
                              message = "The note was deleted sucessfully";
                            } else {
                              message = deleteResult?.errorMessage ??
                                  "An error occured";
                            }
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(message),
                              duration: Duration(seconds: 1),
                            ));
                            return deleteResult?.data ?? false;
                          }
                          return result;
                        },
                        background: Container(
                          padding: EdgeInsets.only(left: 16),
                          child: Align(
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                          color: Colors.red,
                        ),
                        child: ListTile(
                          title: Text(
                            _apiResponse.data[index].noteTitle,
                            style:
                            TextStyle(color: Theme
                                .of(context)
                                .primaryColor),
                          ),
                          subtitle: Text("Last edited on " +
                              formatDateTime(
                                  _apiResponse.data[index].lastEditedDateTime ??
                                      _apiResponse.data[index].createdDateTime)),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                builder: (context) =>
                                    NoteModify(
                                      noteID: _apiResponse.data[index].noteID,
                                    )))
                                .then((data) => fetchNotes());
                          },
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        Divider(
                          height: 1,
                          color: Colors.black,
                        ),
                    itemCount: _apiResponse.data.length),
                )
              ],);
            },
          ),
        ));
  }
}
