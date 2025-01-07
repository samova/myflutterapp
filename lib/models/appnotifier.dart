import 'package:flutter/material.dart';
import 'package:mymoney/data/datamanager.dart';
import 'package:mymoney/models/category.dart';
import 'package:mymoney/models/emojiicon.dart';
import 'package:mymoney/models/record.dart';

class AppNotifier extends ChangeNotifier {
  List<Category> categories = [];
  List<RecordData> records = [];
  List<EmojiIcon> emojiicons = [];
  final String tableCategory = 'catemaster';
  final String tableRecord = 'recorddata';
  final String tableIcon = 'iconmaster';
  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  void updateSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> loadEmojiIcons() async {
    final maps = await Datamanager.instance.getAllItems(tableIcon);
    emojiicons = maps.map((map) => EmojiIcon.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addEmojiIcon(EmojiIcon icon) async {
    await Datamanager.instance.addItem(tableIcon, icon.toMap());
    emojiicons.add(icon);
    notifyListeners();
  }

  Future<void> deleteEmojiIcons(List<EmojiIcon> icons) async {
    for (var icon in icons) {
      await Datamanager.instance.deleteItem(tableIcon, icon.toMap());
      emojiicons.remove(icon);
    }
    notifyListeners();
  }

  Future<void> loadCategories(String? catetype) async {
    final maps = catetype == null 
      ? await Datamanager.instance.getAllItems(tableCategory) 
      : await Datamanager.instance.getItems(tableCategory, catetype);
    categories = maps.map((map) => Category.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    await Datamanager.instance.addItem(tableCategory, category.toMap());
    categories.add(category);
    notifyListeners();
  }

  Future<void> deleteCategory(Category category) async {
    await Datamanager.instance.deleteItem(tableCategory, category.toMap());
    categories.remove(category);
    notifyListeners();
  }

  Future<List<RecordData>> loadRecords(String? type) async {
    final maps = type == null
        ? await Datamanager.instance.getAllItems(tableRecord)
        : await Datamanager.instance.getItems(tableRecord, type);
    records = maps.map((map) => RecordData.fromMap(map)).toList();
    notifyListeners();
    return records;
  }

  Future<void> addRecord(RecordData record) async {
    await Datamanager.instance.addItem(tableRecord, record.toMap());
    records.add(record);
    notifyListeners();
  }

  Future<void> deleteRecord(RecordData record) async {
    await Datamanager.instance.deleteItem(tableRecord, record.toMap());
    records.remove(record);
    notifyListeners();
  }
}