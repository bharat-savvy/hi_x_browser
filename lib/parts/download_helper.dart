import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class DownloadHelper {
  static Future<void> downloadFile(
      String url, String filename, Function(String, double) onProgressCallback) async {
    try {
      await FileDownloader.downloadFile(
        url: url,
        name: filename,
        onProgress: (String? fileName, double? progress) {
          if (fileName != null && progress != null) {
            print('FILE $fileName HAS PROGRESS $progress');
            onProgressCallback(fileName, progress);
          }
        },
        onDownloadCompleted: (String? path) {
          if (path != null) {
            print('FILE DOWNLOADED TO PATH: $path');
          }
        },
        onDownloadError: (String? error) {
          if (error != null) {
            print('DOWNLOAD ERROR: $error');
          }
        },
      );
    } catch (e) {
      print('Error downloading file: $e');
    }
  }
}
