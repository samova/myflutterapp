import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

String _currentDate = '';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    _currentDate = '${DateTime.now().year}年${DateTime.now().month}月';
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Add this line
      home: MyHomePage(title: _currentDate),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _selectedType = 'Income';
  String _selectedCategory = 'Salary';
  final List<String> _incomeCategories = ['Salary', 'Bonus', 'Investment'];
  final List<String> _expendCategories = ['Food', 'Transport', 'Entertainment'];

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ?? 0;
    });
  }

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', _counter);
  }

  void _showDataInputDialog() {
    TextEditingController _textFieldController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Input Dialog'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedType = 'Income';
                        _selectedCategory = _incomeCategories[0];
                      });
                    },
                    child: Card(
                      color: _selectedType == 'Income' ? Colors.green : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Income'),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedType = 'Expend';
                        _selectedCategory = _expendCategories[0];
                      });
                    },
                    child: Card(
                      color: _selectedType == 'Expend' ? Colors.red : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Expend'),
                      ),
                    ),
                  ),
                ],
              ),
              DropdownButton<String>(
                value: _selectedCategory,
                items: (_selectedType == 'Income'
                        ? _incomeCategories
                        : _expendCategories)
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              TextField(
                controller: _textFieldController,
                decoration: const InputDecoration(hintText: "Enter amount"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                String key = '$_selectedType-$_selectedCategory';
                int value = int.tryParse(_textFieldController.text) ?? 0;
                prefs.setInt(key, value);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCategoryInputDialog() {
    TextEditingController _categoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: DefaultTabController(
            length: 2,
            initialIndex: _selectedType == 'Income' ? 0 : 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TabBar(
                  onTap: (index) {
                    setState(() {
                      _selectedType = index == 0 ? 'Income' : 'Expend';
                    });
                  },
                  tabs: [
                    Tab(text: 'Income'),
                    Tab(text: 'Expend'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(hintText: "Enter category"),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                String key = 'categories_$_selectedType';
                List<String> categories = prefs.getStringList(key) ?? [];
                categories.add(_categoryController.text);
                await prefs.setStringList(key, categories);

                setState(() {
                  if (_selectedType == 'Income') {
                    _incomeCategories.add(_categoryController.text);
                  } else {
                    _expendCategories.add(_categoryController.text);
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: _showCategoryInputDialog,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDataInputDialog,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
