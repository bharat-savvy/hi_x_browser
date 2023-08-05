import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:logger/logger.dart';
import 'package:nothing_browser/initialpages/appcolors.dart';
import 'package:nothing_browser/parts/quotecontainerdownloader.dart';
import 'package:nothing_browser/parts/theme_provider.dart';
import 'package:provider/provider.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  late ThemeProvider themeProvider;
  final Logger _logger = Logger();


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider = Provider.of<ThemeProvider>(context);
  }

  final TextEditingController _urlController = TextEditingController();

  Future<void> downloadFile(
      String url, String filename, Function(String, double) onProgressCallback) async {
    try {
      await FileDownloader.downloadFile(
        url: url,
        name: filename,
        onProgress: (String? fileName, double? progress) {
          if (fileName != null && progress != null) {
            _logger.d('FILE $fileName HAS PROGRESS $progress');
            onProgressCallback(fileName, progress);
          }
        },
        onDownloadCompleted: (String? path) {
          if (path != null) {
            _logger.d('FILE DOWNLOADED TO PATH: $path');
          }
        },
        onDownloadError: (String? error) {
          if (error != null) {
            _logger.e('DOWNLOAD ERROR: $error');
          }
        },
      );
    } catch (e) {
      _logger.e('Error downloading file: $e');
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
                child: Container(
                  width: 315,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                  child: Card(
                    elevation: 0,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    child: TextFormField(
                      controller: _urlController,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Enter URL',
                        labelStyle: const TextStyle(color: Colors.red),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 16.0,
                        ),
                        
                        filled: true,
                        fillColor: themeMode == ThemeMode.light ? AppColors.lightBlue : AppColors.firefoxPurple,
                        prefixIcon: const Icon(Icons.link, color: Colors.red),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.downloading,
                          color: Colors.red,
                          ),
                          onPressed: () async {
                            String url = _urlController.text;
                            if (url.isNotEmpty) {
                              final filename = url.substring(url.lastIndexOf('/') + 1);
                              await downloadFile(url, filename, (fileName, progress) {
                                // Update your UI with the progress (e.g., show a progress bar)
                                // You can access 'fileName' and 'progress' here.
                              });
                            }
                          },
                        )// Use a prefix icon instead of a suffix icon
                      ),
                    ),
                  ),
                ),


              ),
              ElevatedButton(
                onPressed: () async {
                  String url = _urlController.text;
                  if (url.isNotEmpty) {
                    final filename = url.substring(url.lastIndexOf('/') + 1);
                    await downloadFile(url, filename, (fileName, progress) {
                      // Update your UI with the progress (e.g., show a progress bar)
                      // You can access 'fileName' and 'progress' here.
                    });
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
