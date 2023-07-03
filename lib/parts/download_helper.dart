import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

class NotificationHelper {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initializeNotifications() async {
    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showDownloadNotification(
      String fileName, int progress) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      importance: Importance.high,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
      indeterminate: progress == 0,
    );
    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Downloading File',
      fileName,
      platformChannelSpecifics,
      payload: fileName,
    );
  }

  static Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }
}
