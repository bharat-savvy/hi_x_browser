import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nothing_browser/initialpages/appcolors.dart';
import 'package:nothing_browser/downloadrelated/downloadpage.dart';
import 'package:nothing_browser/pages/mainpage.dart';
import 'package:nothing_browser/thememode/theme_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';


class HeaderPage extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onRefresh; // Callback function for refresh action

  const HeaderPage({
    Key? key,
    required this.controller,
    required this.onSubmitted,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<HeaderPage> createState() => _HeaderPageState();
}

class _HeaderPageState extends State<HeaderPage> {
  late ThemeProvider themeProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider = Provider.of<ThemeProvider>(context);
  }

  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Emergency Exit',
            style: GoogleFonts.lato(
              fontSize: 20,
              color: Colors.red
            ),
          ),
          content: Text('Please note that using this feature will exit the Hi xBrowser but it will still available on Device tab.',
            style: GoogleFonts.lato(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                exit(0); // Close the entire app
              },
              child: const Text('Yes'),
            ),

          ],
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    final themeMode = themeProvider.themeMode;

    final headerContainer = Material(
      elevation: 4,
      child: Container(
        color: themeMode == ThemeMode.light
            ? AppColors.lightBlue
            : AppColors.firefoxPurple, // Set the color based on the theme mode
        height: 45,
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu),

              onPressed: () {
                Scaffold.of(context).openDrawer();
              }, // Call the onRefresh callback
            ),
            IconButton(
              icon: const Icon(Icons.refresh),

              onPressed: widget.onRefresh, // Call the onRefresh callback
            ),
            Expanded(
              child: Card(
                elevation: 3,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 5.0),
                    filled: true,
                    fillColor: AppColors.lightBlue,
                    hintText: 'Search Here....',
                    hintStyle: const TextStyle(
                      color: AppColors.firefoxPurple,
                      fontSize: 12.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  textAlign: TextAlign.center,
                  controller: widget.controller,
                  keyboardType: TextInputType.url,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: AppColors.firefoxPurple,
                  ),
                  onSubmitted: widget.onSubmitted,
                ),
              ),
            ),


            IconButton(
              icon: const Icon(
                Icons.download_for_offline_outlined,
              ),
              onPressed: () {
                navigateToDownloadPage(context);
              },
            ),
            IconButton(
               // Set the color based on the theme mode
              icon: const Icon(
                Icons.home_outlined,
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboarddPage()),
                );
              },
            ),

            IconButton(
              icon: const Icon(
                Icons.power_settings_new,
                color: Colors.red,
              ),
              onPressed: () {
                _showExitConfirmationDialog(context);
              },
            ),


          ],
        ),
      ),
    );

    return Column(
      children: [
        headerContainer,
      ],
    );
  }
}

void navigateToDownloadPage(BuildContext context) {
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.fade, // or PageTransitionType.scale
      child: const DownloadPage(),
      duration: const Duration(milliseconds: 400),
    ),
  );
}
