import 'package:flutter/material.dart';
import 'package:nothing_browser/dashboard.dart';
import 'package:nothing_browser/pages/aol.dart';
import 'package:nothing_browser/pages/ask.dart';
import 'package:nothing_browser/pages/bing.dart';
import 'package:nothing_browser/pages/duck.dart';
import 'package:nothing_browser/pages/ecosia.dart';
import 'package:nothing_browser/pages/google.dart';
import 'package:nothing_browser/pages/start.dart';
import 'package:nothing_browser/pages/wolfarm.dart';
import 'package:nothing_browser/pages/yahoo.dart';
import 'package:nothing_browser/pages/yandex.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});







  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nothing Browser',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,

      initialRoute: '/',

      routes: {
        '/': (context) => const DashboardPage(),
        '/duckduck': (context) => const DuckPage(),
        '/aold': (context) => const AolPage(),
        '/askd': (context) => const AskPage(),
        '/bingd': (context) => const BingPage(),
        '/ecosiad': (context) => const EcosiaPage(),
        '/googled': (context) => const GooglePage(),
        '/startd': (context) => const StartPage(),
        '/wolfarmd': (context) => const WolfarmPage(),
        '/yahood': (context) => const YahooPage(),
        '/yandexd': (context) => const YandexPage(),










      },


    );
  }
}