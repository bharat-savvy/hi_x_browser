import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:nothing_browser/initialpages/appcolors.dart';
import 'package:nothing_browser/parts/floatingpage.dart';
import 'package:nothing_browser/thememode/theme_provider.dart';
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


  Future<void> downloadFile(String url, String filename,
      Function(String, double) onProgressCallback) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Row(
          children: [
            Image.asset('assets/images/FinalLogo.png',
              width: 20,
            ),

            const Text('Download starting...'),
          ],
        )),
      );

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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Row(
                children: [
                  Image.asset('assets/images/FinalLogo.png',
                    width: 20,
                  ),
                  Text('Download completed for $filename'),
                ],
              )),
            );
          }
        },
        onDownloadError: (String? error) {
          if (error != null) {
            _logger.e('DOWNLOAD ERROR: $error');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Row(
                children: [
                  Image.asset('assets/images/FinalLogo.png',
                    width: 20,
                  ),
                  const Text('Download error'),
                ],
              )),
            );
          }
        },
      );
    } catch (e) {
      _logger.e('Error downloading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Row(
          children: [
            Image.asset('assets/images/FinalLogo.png',
            width: 20,
            ),
            const Text('Error Downloading File'),
          ],
        )
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = themeProvider.themeMode;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: themeMode == ThemeMode.light
                ? AppColors.lightBlue
                : AppColors.firefoxPurple,
            centerTitle: true,
            title: Image.asset(
              'assets/images/LogoFinal.png',
              height: 40,
            ),


        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: TextFormField(
                        controller: _urlController,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Paste Link Here',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 16.0,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          prefixIcon: const Icon(Icons.link, color: Colors.grey),
                          // Use a prefix icon instead of a suffix icon
                          suffixIcon: IconButton(
                            onPressed: () {
                              _urlController.clear();
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(5),
                onTap: () async {
                  String url = _urlController.text;
                  if (url.isNotEmpty) {
                    final filename = url.substring(url.lastIndexOf('/') + 1);
                    await downloadFile(url, filename, (fileName, progress) {
                      // Update your UI with the progress (e.g., show a progress bar)
                      // You can access 'fileName' and 'progress' here.
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blueGrey,

                  ),
                  height: 40,
                  width: 90,
                  child: Center(
                    child: Text(
                      'Download',
                      style: GoogleFonts.lato(
                        color: Colors.white
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: const FloatingButtonPage()
      ),
    );
  }
}
Future<void> showDownloadNotification(String fileName, int progress) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'download_channel',
      title: 'File Download',
      body: 'Downloading: $fileName\nProgress: $progress%',
    ),
  );
}
