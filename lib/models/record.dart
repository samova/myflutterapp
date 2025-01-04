import 'package:uuid/uuid.dart';

class RecordData {
  String? id; // Change to String
  String catetype;
  String category;
  int amount;
  String date;
  String note;


  RecordData({this.id, required this.catetype, required this.category, required this.amount, required this.date, required this.note});

  Map<String, dynamic> toMap() {
    var uuid = Uuid();
    var map = <String, dynamic>{
      'recordid': id ?? uuid.v4(), // Generate unique string ID if id is null
      'catetype': catetype,
      'category': category,
      'amount': amount,
      'date': date,
      'note': note,
    };
    return map;
  }


}