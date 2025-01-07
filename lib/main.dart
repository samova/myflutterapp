import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mymoney/models/appnotifier.dart';
import 'package:mymoney/views/catepage.dart';
import 'package:mymoney/views/home.dart';
import 'package:mymoney/views/iconpage.dart';
import 'package:mymoney/views/splashpage.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

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
          Locale('en', 'US'),
          Locale('ja', 'JP'),
          Locale('zh', 'CN'),
        ],
        home: MyHomePage(title: 'MyMoney'),
        routes: {
          //'/home': (context) => const MyHomePage(title: 'MyMoney'),
          '/catepage': (context) => const Catepage(),
          '/iconpage': (context) => const IconPage(),
        },
      ),
    );
  }
}



