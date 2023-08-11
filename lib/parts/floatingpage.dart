import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nothing_browser/downloadrelated/downloadpage.dart';
import 'package:nothing_browser/initialpages/help.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class FloatingButtonPage extends StatefulWidget {
  const FloatingButtonPage({Key? key}) : super(key: key);

  @override
  State<FloatingButtonPage> createState() => _FloatingButtonPageState();
}

class _FloatingButtonPageState extends State<FloatingButtonPage> {

  Future<void> clearAppCache(VoidCallback onSuccess) async {
    await DefaultCacheManager().emptyCache();
    onSuccess.call();
  }

  void _openPlayStore() async {
    const String appId = "digital.taranila.ai2chat"; // Replace with your app's package name
    const String url = "market://details?id=$appId";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Could not launch $url";
    }
  }




  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit App',
          style: GoogleFonts.lato(
            fontSize: 20,
          ),
          ),
          content: Text('Do you want to exit the app?',
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(
          width: 30,
        ),

        SizedBox(
          width: 40,
          height: 40,
          child: FloatingActionButton(
            heroTag: 'playStore',
            backgroundColor: Colors.blueGrey,
            onPressed: _openPlayStore,

            child: const Icon(
              Icons.apps,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        // Help Button
        SizedBox(
          width: 40,
          height: 40,
          child: FloatingActionButton(
            heroTag: 'HelpButton',
            backgroundColor: Colors.blue,
            onPressed: () {
              navigateToHelpPage(context);
            },
            child: const Icon(
              Icons.help_outlined,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        // Cache Button
        SizedBox(
          width: 50,
          height: 50,
          child: FloatingActionButton(
            heroTag: 'CacheButton',
            backgroundColor: Colors.red,
            onPressed: () async {
              await clearAppCache(() {
                CherryToast.success(title: const Text("Cache Cleared"))
                    .show(context);
              });
            },
            child: const Icon(
              Icons.local_fire_department_sharp,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        // Download Button
        SizedBox(
          width: 40,
          height: 40,
          child: FloatingActionButton(
            heroTag: 'downloadButton',
            backgroundColor: Colors.teal,
            onPressed: () {
              navigateToDownloadPage(context);
            },
            child: const Icon(
              Icons.download,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(
          width: 10,
        ),
        // Download Button
        SizedBox(
          width: 40,
          height: 40,
          child: FloatingActionButton(
            heroTag: 'exitButton',
            backgroundColor: Colors.deepPurple,
            onPressed: () {
              _showExitConfirmationDialog(context);
            },
            child: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
          ),
        ),
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

void navigateToHelpPage(BuildContext context) {
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.fade, // or PageTransitionType.scale
      child: const HelpPage(),
      duration: const Duration(milliseconds: 400),
    ),
  );
}
