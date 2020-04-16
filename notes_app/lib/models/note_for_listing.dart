class NoteForListing {
  String noteID;
  String noteTitle;
  DateTime createdDateTime;
  DateTime lastEditedDateTime;

  NoteForListing(
      {this.noteID,
      this.noteTitle,
      this.createdDateTime,
      this.lastEditedDateTime});

  factory NoteForListing.fromJson(Map<String, dynamic> item) {
    return NoteForListing(
      noteID: item['noteID'],
      noteTitle: item['noteTitle'],
      createdDateTime: DateTime.parse(item['createDateTime']),
      lastEditedDateTime: item['latestEditDateTime'] != null
          ? DateTime.parse(item['latestEditDateTime'])
          : null,
    );
  }
}
