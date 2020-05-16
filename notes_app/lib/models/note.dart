class Note {
  String noteID;
  String noteTitle;
  String noteContent;
  DateTime createdDateTime;
  DateTime lastEditedDateTime;

  Note(
      {this.noteID,
      this.noteTitle,
      this.noteContent,
      this.createdDateTime,
      this.lastEditedDateTime});

  factory Note.fromJson(Map<String, dynamic> item) {
    return Note(
      noteID: item['noteID'],
      noteTitle: item['noteTitle'],
      noteContent: item['noteContent'],
      createdDateTime: DateTime.parse(item['createDateTime']),
      lastEditedDateTime: item['latestEditDateTime'] != null
          ? DateTime.parse(item['latestEditDateTime'])
          : null,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'noteID' : noteID,
      'noteTitle' : noteTitle,
      'noteContent' : noteContent,
      'createdDateTime' : createdDateTime.toString(),
      'lastEditedDateTime'  : lastEditedDateTime.toString(),
    };
  }
}
