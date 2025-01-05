import 'package:uuid/uuid.dart';

class RecordData {
  String? id;
  String catetype;
  String category;
  int amount;
  String date;
  String note;

  RecordData({
    this.id,
    required this.catetype,
    required this.category,
    required this.amount,
    required this.date,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    var uuid = Uuid();
    return {
      'recordid': id ?? uuid.v4(),
      'catetype': catetype,
      'category': category,
      'amount': amount,
      'date': date,
      'note': note,
    };
  }

  factory RecordData.fromMap(Map<String, dynamic> map) {
    return RecordData(
      id: map['recordid'],
      catetype: map['catetype'],
      category: map['category'],
      amount: map['amount'],
      date: map['date'],
      note: map['note'],
    );
  }
}