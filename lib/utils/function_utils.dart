String dateTostring(DateTime date) {
  String _stringdate ="";
  _stringdate = date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString();
  return _stringdate;
}

DateTime stringToDate(String date){
  String _dateString = "";
  _dateString = date.substring(6,10)+'-'+date.substring(3,5)+'-'+date.substring(0,2);
  return DateTime.parse(_dateString);
}

String stringToString(String date){
  String _dateString = "";
  _dateString = date.substring(7,9)+'/'+date.substring(5,6)+'-'+date.substring(0,4);
  return _dateString;
}