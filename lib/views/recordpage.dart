import 'package:flutter/material.dart';
import 'package:mymoney/models/appnotifier.dart';
import 'package:mymoney/models/enums.dart';
import 'package:mymoney/models/record.dart';
import 'package:provider/provider.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          title: Text('RecordPage'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.monetization_on_outlined), text: CategoryType.income.name),
              Tab(icon: Icon(Icons.account_balance_wallet), text: CategoryType.expenses.name),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CategoryGridView(catetype: CategoryType.income.name),
            CategoryGridView(catetype: CategoryType.expenses.name),
          ],
        ),
        bottomNavigationBar: InputRecordView(),
      )
    );
  }
}

class InputRecordView extends StatefulWidget {
  const InputRecordView({super.key});

  @override
  State<InputRecordView> createState() => _InputRecordViewState();
}

class _InputRecordViewState extends State<InputRecordView> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _amountController,
              decoration: InputDecoration(
                hintText: 'Enter record',
              ),
            ),
          ),
          SizedBox(width: 20),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              final selectedCategory = context.read<AppNotifier>().selectedCategory;
              if (selectedCategory != null) {
                context.read<AppNotifier>().addRecord(RecordData(
                  catetype: DefaultTabController.of(context).index == 0 ? CategoryType.income.name : CategoryType.expenses.name,
                  category: selectedCategory,
                  amount: int.parse(_amountController.text),
                  date: DateTime.now().toIso8601String(),
                  note: _noteController.text,
                ));
                _noteController.clear();
                _amountController.clear();
                Navigator.of(context).pop();
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Please select a category'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class CategoryGridView extends StatefulWidget {
  final String catetype;
  const CategoryGridView({super.key, required this.catetype});

  @override
  State<CategoryGridView> createState() => _CategoryGridViewState();
}

class _CategoryGridViewState extends State<CategoryGridView> {
  @override
  Widget build(BuildContext context) {
    final selectedCategory = context.watch<AppNotifier>().selectedCategory;

    return GridView.count(
      crossAxisCount: 6,
      children: context.read<AppNotifier>().categories.map((category) {
        final isSelected = selectedCategory == category.category;
        return GestureDetector(
          onTap: () {
            context.read<AppNotifier>().updateSelectedCategory(isSelected ? null : category.category);
          },
          child: Card(
            color: isSelected ? Colors.blueAccent : Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(category.icon, style: TextStyle(fontSize: 24)),
                SizedBox(height: 8),
                Text(category.category),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
