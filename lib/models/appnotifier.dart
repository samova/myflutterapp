import 'package:flutter/material.dart';
import 'package:mymoney/data/datamanager.dart';
import 'package:mymoney/models/category.dart';
import 'package:mymoney/models/record.dart';
import 'package:mymoney/models/enums.dart';

class AppNotifier extends ChangeNotifier {
List<Category> categories = [];
List<RecordData> records = [];
final String tableCategory = 'catemaster';
final String tableRecord = 'recorddata';

  void loadCategories(CategoryType? type) async {
    Datamanager dataManager = Datamanager();
    if(type == null){
      List<Map<dynamic, dynamic>> maps = await dataManager.getAllItems(tableCategory);
      categories = maps.map((map) => Category(
        catetype: map['catetype'],
        category: map['category'],
        icon: map['icon'],
        budget: map['budget'],
      )).toList();
      }else{
      List<Map<dynamic, dynamic>> maps = await dataManager.getItems(tableCategory,type.name);
      categories = maps.map((map) => Category(
        catetype: map['catetype'],
        category: map['category'],
        icon: map['icon'],
        budget: map['budget'],
      )).toList();
    }
    dataManager.close();
    notifyListeners();
  }

  void addCategory(Category category) async {
    Datamanager dataManager = Datamanager();
    dataManager.addItem(tableCategory,category.toMap());
    dataManager.close();
    notifyListeners();
  }

  void deleteCategory(Category category) async {
    Datamanager dataManager = Datamanager();
    dataManager.deleteItem(tableCategory,category.toMap());
    dataManager.close();
    notifyListeners();
  }
  
  void loadRecords(CategoryType? type) async {
    Datamanager dataManager = Datamanager();
    if(type == null){
      List<Map<dynamic, dynamic>> maps = await dataManager.getAllItems(tableRecord);
      records = maps.map((map) => RecordData(
        id: map['id'],
        date: map['date'],
        catetype: map['catetype'],
        category: map['category'],
        amount: map['amount'],
        note: map['note'],
      )).toList();
      }else{
      List<Map<dynamic, dynamic>> maps = await dataManager.getItems(tableRecord,type.name);
      records = maps.map((map) => RecordData(
        id: map['id'],
        date: map['date'],
        catetype: map['catetype'],
        category: map['category'],
        amount: map['amount'],
        note: map['note'],
      )).toList();
    }
    dataManager.close();
    notifyListeners();
  }

  void addRecord(RecordData record) async {
    Datamanager dataManager = Datamanager();
    dataManager.addItem(tableRecord,record.toMap());
    dataManager.close();
    notifyListeners();
  }

  void deleteRecord(RecordData record) async {
    Datamanager dataManager = Datamanager();
    dataManager.deleteItem(tableRecord,record.toMap());
    dataManager.close();
    notifyListeners();
  }
}