import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mymoney/models/appnotifier.dart';
import 'package:mymoney/views/home.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

String currentDate = '${DateTime.now().year}年${DateTime.now().month}月';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppNotifier(),
      child: MaterialApp(
        title: 'My Money',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
          localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [
    Locale('en', 'us'), 
    Locale('ja', 'japanese'), 
    Locale('zh', 'chinese')
  ],
        home: MyHomePage(title: currentDate),
      ),
    );
  }
}



