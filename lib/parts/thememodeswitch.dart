import 'package:flutter/material.dart';
import 'package:nothing_browser/parts/theme_provider.dart';
import 'package:provider/provider.dart';



class ThemeModeSwitch extends StatefulWidget {
  const ThemeModeSwitch({super.key});

  @override
  State<ThemeModeSwitch> createState() => _ThemeModeSwitchState();
}

class _ThemeModeSwitchState extends State<ThemeModeSwitch> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return IconButton(
          icon: Icon(themeProvider.themeMode == ThemeMode.light
              ? Icons.light_mode
              : Icons.light_mode),
          color: themeProvider.themeMode == ThemeMode.light
              ? Colors.black
              : Colors.red,
          onPressed: () {
            final newThemeMode =
            themeProvider.themeMode == ThemeMode.light
                ? ThemeModeType.dark
                : ThemeModeType.light;
            themeProvider.setThemeModeType(newThemeMode);
          },
        );
      },
    );
  }
}
