import 'package:flutter/material.dart';
import 'package:mymoney/models/category.dart';
import 'package:mymoney/models/record.dart';
import 'package:mymoney/main.dart';

class AppNotifier extends ChangeNotifier {
  List<Category> categories = [];
  List<RecordData> records = [];
  final String tableCategory = 'catemaster';
  final String tableRecord = 'recorddata';

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  void updateSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> loadCategories(String? catetype) async {
    print('Fetching categories from database...');
    final maps = catetype == null 
      ? await dataManager!.getAllItems(tableCategory) 
      : await dataManager!.getItems(tableCategory, catetype);
    categories = maps.map((map) => Category.fromMap(map)).toList();
    print('Categories fetched: ${categories.length}');
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    await dataManager!.addItem(tableCategory, category.toMap());
    categories.add(category);
    notifyListeners();
  }

  Future<void> deleteCategory(Category category) async {
    await dataManager!.deleteItem(tableCategory, category.toMap());
    categories.remove(category);
    notifyListeners();
  }

  Future<List<RecordData>> loadRecords(String? type) async {
    final maps = type == null
        ? await dataManager!.getAllItems(tableRecord)
        : await dataManager!.getItems(tableRecord, type);
    records = maps.map((map) => RecordData.fromMap(map)).toList();
    notifyListeners();
    return records;
  }

  Future<void> addRecord(RecordData record) async {
    await dataManager!.addItem(tableRecord, record.toMap());
    notifyListeners();
  }

  Future<void> deleteRecord(RecordData record) async {
    await dataManager!.deleteItem(tableRecord, record.toMap());
    notifyListeners();
  }
}