import 'package:flutter/material.dart';
import 'package:mymoney/models/appnotifier.dart';
import 'package:mymoney/models/enums.dart';
import 'package:mymoney/views/inputdialog.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MyHomePage2 extends StatefulWidget {
  final String title;
  const MyHomePage2({super.key, required this.title});

  @override
  State<MyHomePage2> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage2> {
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final appNotifier = context.watch<AppNotifier>();
    appNotifier.loadEmojiIcons();
    final expenses = appNotifier.records.where((record) => isSameDay(DateTime.parse(record.date), _selectedDay)).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () => Navigator.of(context).pushNamed('/catepage'),
          ),
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () => Navigator.of(context).pushNamed('/iconpage'),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    appNotifier.deleteRecord(expenses[index]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${expenses[index].category} deleted')),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(expenses[index].category),
                    subtitle: Text(expenses[index].note),
                    trailing: Text(expenses[index].amount.toString()),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add An Expense'),
                content: InputDialog(cardMode: CardMode.record),
              );
            },
          );
        },
      ),
    );
  }
}