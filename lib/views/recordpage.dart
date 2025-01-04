import 'package:flutter/material.dart';
import 'package:mymoney/models/appnotifier.dart';
import 'package:mymoney/models/enums.dart';
import 'package:mymoney/models/record.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              AppNotifier().addRecord(RecordData(
                catetype: DefaultTabController.of(context).index == 0 ? CategoryType.income.name : CategoryType.expenses.name,
                category: _Controller.text,
                amount: int.parse(_amountController.text),
                date: DateTime.now().toIso8601String(),
                note: _noteController.text,
              ));
              _noteController.clear();
              _amountController.clear();
            },
          ),
        ],
      ),
    );
  }
}

class CategoryGridView extends StatelessWidget {
  final String catetype;
  const CategoryGridView({super.key, required this.catetype});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: AppNotifier().categories.map((category) {
        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(category.icon, style: TextStyle(fontSize: 24)),
              SizedBox(height: 8),
              Text(category.category),
            ],
          ),
        );
      }).toList(),
    );
  }
}
