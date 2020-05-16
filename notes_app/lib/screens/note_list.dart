import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:notesapp/models/api_response.dart';
import 'package:notesapp/models/note_for_listing.dart';
import 'package:notesapp/screens/note_delete.dart';
import 'package:notesapp/services/database_helper.dart';
import 'package:notesapp/services/notes_service.dart';
import 'note_modify.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NotesService get service => GetIt.I<NotesService>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  APIResponse _apiResponse;
  bool _isLoading = false;
  bool _isThereInternet = true;
  DatabaseHelper _databaseHelper = DatabaseHelper();
  var offlineJsonData;

  formatDateTime(DateTime dateTime) {
    return DateFormat.yMMMd().format(dateTime);
  }

  Future fetchNotes() async {
    _apiResponse = await service.getNotesList();
  }

  Future _checkInternetConnectivity() async {
    setState(() {
      _isLoading = true;
    });
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none)
      return false;
    else if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) return true;
  }

  @override
  void initState() {
    print("init");

    setState(() {
      _isLoading = true;
    });
    _checkInternetConnectivity().then((value) {
      _isThereInternet = value;
      if (_isThereInternet) {
        fetchNotes().then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      } else {
        _databaseHelper.getNoteMapList().then((databaseValue) {
          offlineJsonData = databaseValue;
          print(offlineJsonData.toString());
          setState(() {
            _isLoading = false;
          });
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _isThereInternet
                ? Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      title: Text("Notes"),
                    ),
                    floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                                MaterialPageRoute(builder: (context) => NoteModify(isThereInternet: _isThereInternet)))
                            .then((_) => fetchNotes());
                      },
                    ),
                    body: RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: fetchNotes,
                      child: Builder(
                        builder: (context) {
                          if (_isLoading) return Center(child: CircularProgressIndicator());
                          //if (_apiResponse.error)
                          //return Center(child: Text(_apiResponse.errorMessage));
                          return Column(
                            children: <Widget>[
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
                                          final result =
                                              await showDialog(context: context, builder: (context) => NoteDelete());
                                          if (result) {
                                            final deleteResult =
                                                await service.deleteNote(_apiResponse.data[index].noteID);
                                            var message;
                                            if (deleteResult != null && deleteResult.data == true) {
                                              message = "The note was deleted sucessfully";
                                            } else {
                                              message = deleteResult?.errorMessage ?? "An error occured";
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
                                            style: TextStyle(color: Theme.of(context).primaryColor),
                                          ),
                                          subtitle: Text("Last edited on " +
                                              formatDateTime(_apiResponse.data[index].lastEditedDateTime ??
                                                  _apiResponse.data[index].createdDateTime)),
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) => NoteModify(
                                                          isThereInternet: _isThereInternet,
                                                          noteID: _apiResponse.data[index].noteID,
                                                        )))
                                                .then((data) => fetchNotes());
                                          },
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) => Divider(
                                          height: 1,
                                          color: Colors.black,
                                        ),
                                    itemCount: _apiResponse.data.length),
                              )
                            ],
                          );
                        },
                      ),
                    ))
                : Scaffold(
                    appBar: AppBar(
                      title: Text("Notes"),
                      automaticallyImplyLeading: false,
                      elevation: 0,
                    ),
                    floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          print("is there internet" + _isThereInternet.toString());
                          return NoteModify(isThereInternet: _isThereInternet);
                        })).then((value) {

                        });
                      },
                    ),
                    body: _isLoading == true
                        ? CircularProgressIndicator()
                        : ListView.separated(
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: ValueKey(offlineJsonData[index]['noteID']),
                                direction: DismissDirection.startToEnd,
                                onDismissed: (direction) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _databaseHelper.getNoteMapList().then((databaseValue) {
                                    offlineJsonData = databaseValue;
                                    print(offlineJsonData.toString());
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  });
                                },
                                confirmDismiss: (direction) async {
                                  final result = await showDialog(context: context, builder: (context) => NoteDelete());
                                  if (result) {
                                    final deleteResult = await _databaseHelper
                                        .deleteNote(offlineJsonData[index]['noteID'])
                                        .then((deleteResult) {
                                      var message;
                                      if (deleteResult == 1) {
                                        message = "The note was deleted successfully";
                                      } else {
                                        message = "An error occurred";
                                      }
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text(message),
                                        duration: Duration(seconds: 1),
                                      ));
                                      return deleteResult ?? 0;
                                    });
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
                                    offlineJsonData[index]['noteTitle'],
                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                  ),
                                  subtitle: Text(offlineJsonData[index]['noteContent']),
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                      return NoteModify(
                                          isThereInternet: _isThereInternet, noteID: offlineJsonData[index]['noteID']);
                                    })).then((data) {});
                                  },
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  color: Colors.black,
                                ),
                            itemCount: offlineJsonData.length ?? 1),
                  ));
  }
}
