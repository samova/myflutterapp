import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mymoney/models/appnotifier.dart';
import 'package:mymoney/models/category.dart';
import 'package:mymoney/models/enums.dart';
import 'package:provider/provider.dart';

class Catepage extends StatelessWidget {
  const Catepage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Builder(
        builder: (context) {
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
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                final catetype = DefaultTabController.of(context).index == 0
                  ? CategoryType.income.name
                  : CategoryType.expenses.name;
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Add $catetype Category'),
                      content: InputDialog(catetype:catetype),
                    );
                  },
                );
              },
            ),
          );
        }
      ),
    );
  }
}

class CategoryListView extends StatefulWidget {
  final String catetype;
  const CategoryListView({super.key, required this.catetype});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  bool isFirstBuild = true;

  @override
  Widget build(BuildContext context) {
    final appNotifier = context.watch<AppNotifier>();
    if (isFirstBuild) {
      appNotifier.loadCategories(widget.catetype);
      isFirstBuild = false;
    }
    return ListView.builder(
      itemCount: appNotifier.categories.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            appNotifier.deleteCategory(appNotifier.categories[index]);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${appNotifier.categories[index].category} deleted')),
            );
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          child: ListTile(
            leading: Text(appNotifier.categories[index].icon),
            title: Text(appNotifier.categories[index].category),
          ),
        );
      },
    );
  }
}

class InputDialog extends StatefulWidget {
  final String catetype;
  const InputDialog({super.key, required this.catetype});

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  final TextEditingController cateController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  String selectedEmoji = '💰';

  @override
  Widget build(BuildContext context) {
    final appNotifier = context.read<AppNotifier>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<String>(
          alignment: Alignment.center,
          isExpanded: true,
          value: selectedEmoji,
          items: ['💰', '🤑', '🧧', '🪙', '🚗', '🏥', '🏡', '🚃', '🎡', '🏖️', '🎊', '🎁', '🛍️', '📱'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: 24)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedEmoji = newValue!;
            });
          },
        ),
        SizedBox(height: 20),
        TextField(
          controller: cateController,
          decoration: InputDecoration(
            hintText: 'Enter category',
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9\s\p{Emoji_Presentation}]*$')),
          ],
        ),
        SizedBox(height: 20),
        if (widget.catetype == CategoryType.expenses.name)
          TextField(
            controller: budgetController,
            decoration: InputDecoration(
              hintText: 'Enter budget',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        SizedBox(height: 20),
        TextButton(
          child: Text('OK'),
          onPressed: () {
            if (cateController.text.isEmpty || (widget.catetype == CategoryType.expenses.name && budgetController.text.isEmpty)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please fill in all fields')),
              );
            } else {
              appNotifier.addCategory(Category(
                catetype: widget.catetype,
                category: cateController.text,
                budget: budgetController.text.isEmpty ? 0 : int.parse(budgetController.text),
                icon: selectedEmoji,
              ));
              cateController.clear();
              budgetController.clear();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}