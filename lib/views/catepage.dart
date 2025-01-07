import 'package:flutter/material.dart';
import 'package:mymoney/models/appnotifier.dart';
import 'package:mymoney/models/enums.dart';
import 'package:mymoney/views/inputdialog.dart';
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
                      content: InputDialog(cardMode: DefaultTabController.of(context).index == 0 
                      ? CardMode.income 
                      : CardMode.expenses),
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
            trailing: widget.catetype == CategoryType.expenses.name
                ? Text('budget: ${appNotifier.categories[index].budget}')
                : null,
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Edit Category'),
                    content: InputDialog(
                      cardMode: widget.catetype == CategoryType.income.name ? CardMode.income : CardMode.expenses,
                      mapData: appNotifier.categories[index].toMap(),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}