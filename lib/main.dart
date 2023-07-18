import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nothing_browser/initialpages/appcolors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nothing_browser/pages/mainpage.dart';
import 'package:provider/provider.dart';
import 'package:nothing_browser/parts/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
          title: 'Nothing Browser',
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
            scaffoldBackgroundColor: AppColors.firefoxPurple,
          ),
          themeMode: themeMode,
          initialRoute: '/',
          routes: {
            '/': (context) => const DashboarddPage(),
          },
        );
      },
    );
  }
}
