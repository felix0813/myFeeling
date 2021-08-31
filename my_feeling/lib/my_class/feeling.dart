class Feeling {
  var title;
  var content;
  var group;
  var datetime;
  var id;

  Feeling(int _id, String _title, String _group, String _datetime,
      String _content) {
    title = _title;
    content = _content;
    datetime = _datetime;
    group = _group;
    id = _id;
  }
}
