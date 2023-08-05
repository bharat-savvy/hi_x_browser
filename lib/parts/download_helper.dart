import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:logger/logger.dart';

class DownloadHelper {
  static final Logger _logger = Logger();

  static Future<void> downloadFile(
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
}
