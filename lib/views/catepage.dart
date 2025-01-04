import 'package:flutter/material.dart';
import 'package:mymoney/models/appnotifier.dart';
import 'package:mymoney/models/category.dart';
import 'package:mymoney/models/enums.dart';

class Catepage extends StatelessWidget {
  const Catepage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catepage'),
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.monetization_on_outlined), text: CategoryType.income.name),
            Tab(icon: Icon(Icons.account_balance_wallet), text: CategoryType.expenses.name),
          ],
        ),
      ),
      body: TabBarView(
          children: [
            CategoryListView(catetype: CategoryType.income.name),
            CategoryListView(catetype: CategoryType.expenses.name),
          ],
        ),
      bottomNavigationBar: InputCateView(),
  );
  }
}
class InputCateView extends StatefulWidget {
  const InputCateView({super.key});

  @override
  State<InputCateView> createState() => _InputCateViewState();
}

class _InputCateViewState extends State<InputCateView> {
  final TextEditingController _cateController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  String _selectedEmoji = '💰';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          DropdownButton<String>(
            hint: Text('Select Emoji'),
            items: ['💰', '🤑', '🧧', '🪙', '🚗', '🏥', '🏡', '🚃', '🎡', '🏖️','🎊','🎁','🛍️','📱'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(fontSize: 24)),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedEmoji = newValue!;
              });
            },
          ),
          Expanded(
            child: TextField(
              controller: _cateController,
              decoration: InputDecoration(
                hintText: 'Enter record',
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: TextField(
              controller: _budgetController,
              decoration: InputDecoration(
                hintText: 'Enter amount',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              AppNotifier().addCategory(Category(
                catetype: DefaultTabController.of(context).index == 0 ? CategoryType.income.name : CategoryType.expenses.name,
                category: _cateController.text,
                budget: int.parse(_budgetController.text),
                icon: _selectedEmoji,
              ));
              _cateController.clear();
              _budgetController.clear();
            },
          ),
        ],
      ),
    );
  }
}

class CategoryListView extends StatelessWidget {
  final String catetype;
  const CategoryListView({super.key, required this.catetype});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: AppNotifier().categories.map((category) {
        return ListTile(
          leading: Text(category.icon),
          title: Text(category.category),
          trailing: 
           ElevatedButton(
            onPressed: () {
              AppNotifier().deleteCategory(category);
            },
            child: Icon(Icons.delete),
          ),
        );
      }).toList(),
    );
  }
}