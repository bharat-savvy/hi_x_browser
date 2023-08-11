import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:nothing_browser/initialpages/appcolors.dart';
import 'package:nothing_browser/downloadrelated/downloadpage.dart';
import 'package:nothing_browser/initialpages/help.dart';
import 'package:nothing_browser/pages/mainpage.dart';
import 'package:provider/provider.dart';
import 'package:nothing_browser/thememode/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.level = Level.warning; // Set the log level to warning or error in production

  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelKey: 'download_channel',
        channelName: 'Download Notifications',
        channelDescription: 'Notifications for file downloads',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        vibrationPattern: lowVibrationPattern,
        importance: NotificationImportance.High,
        enableLights: true,
        enableVibration: true,
        playSound: false
      ),
    ],
  );


  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.firefoxPurple,
      statusBarIconBrightness: Brightness.light, // Set the status bar text color to light
      systemNavigationBarColor: AppColors.firefoxPurple,
    ),
  );

  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // Add more providers here if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {

        final themeMode = themeProvider.themeMode;
        final statusBarColor = themeMode == ThemeMode.light
            ? AppColors.lightBlue
            : AppColors.firefoxPurple;
        final statusBarIconBrightness = themeMode == ThemeMode.light
            ? Brightness.dark
            : Brightness.light; // Set the status bar text color to light for light theme
        final navBarColor = themeMode == ThemeMode.light
            ? AppColors.lightBlue
            : AppColors.firefoxPurple;

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: statusBarColor,
            statusBarIconBrightness: statusBarIconBrightness,
            systemNavigationBarColor: navBarColor,
          ),
        );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Hi xBrowser',
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.indigo,
            brightness: Brightness.light,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: AppColors.lightBlue,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: AppColors.firefoxPurple,
          ),
          themeMode: themeMode,
          initialRoute: '/',
          routes: {
            '/': (context) => const DashboarddPage(),
            '/download': (context) => const DownloadPage(),
            '/help': (context) => const HelpPage(),


          },
        );
      },
    );
  }
}
