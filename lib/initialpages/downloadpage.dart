import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nothing_browser/initialpages/appcolors.dart';
import 'package:nothing_browser/parts/quotecontainerdownloader.dart';
import 'package:nothing_browser/parts/theme_provider.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  late ThemeProvider themeProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider = Provider.of<ThemeProvider>(context);
  }

  final TextEditingController _urlController = TextEditingController();

  Future<void> downloadFile(String url, String filename) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Get the app's documents directory
        Directory documentsDir = await getApplicationDocumentsDirectory();

        // Create a file within the documents directory
        File file = File('${documentsDir.path}/$filename');
        await file.writeAsBytes(response.bodyBytes);

        print('File downloaded to: ${file.path}');
      } else {
        print('Failed to download file');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
  }





  @override
  Widget build(BuildContext context) {

    final themeMode = themeProvider.themeMode;



    return SafeArea(
      child: Scaffold(


        appBar: AppBar(
          backgroundColor: themeMode == ThemeMode.light ? AppColors.lightBlue : AppColors.firefoxPurple,
          centerTitle: true,
          title: Image.asset(
            'assets/images/LogoFinal.png',
            height: 40,

          )
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const QuoteContainerDownloader(),

              const SizedBox(
                height: 70,
              ),





              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _urlController,
                  style: const TextStyle( // Customize the input text style
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Enter URL',
                    labelStyle: TextStyle(color: Colors.red), // Customize the label text style
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0), // Customize the border when the field is focused
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0), // Customize the border when the field is not focused
                    ),
                    suffixIcon: Icon(Icons.link, color: Colors.red), // Add an icon at the end of the input
                  ),
                ),

              ),
              ElevatedButton(
                onPressed: () async {
                  String url = _urlController.text;
                  if (url.isNotEmpty) {
                    String filename = 'downloaded_file'; // Provide your desired filename here
                    await downloadFile(url, filename);
                  }
                },
                child: const Text('Download'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
