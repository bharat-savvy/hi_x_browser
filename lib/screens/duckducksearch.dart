import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nothing_browser/screens/dash.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DuckDuckGoSearchPage extends StatefulWidget {
  final String query;

  const DuckDuckGoSearchPage({Key? key, required this.query}) : super(key: key);

  @override
  State<DuckDuckGoSearchPage> createState() => _DuckDuckGoSearchPageState();
}

class _DuckDuckGoSearchPageState extends State<DuckDuckGoSearchPage> {
  final GlobalKey webViewKey = GlobalKey();

  //InAppWebView Settings//
  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
    // set this option to true to enable downloads
    useOnDownloadStart: true,
    javaScriptCanOpenWindowsAutomatically: true,
    javaScriptEnabled: true,
    supportZoom: true,
    supportMultipleWindows: true,
    allowFileAccess: true,
  );

//Refresh Page Circuler Progress bar
  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(color: Colors.deepOrangeAccent),
            onRefresh: () async {
              defaultTargetPlatform == TargetPlatform.android;
              webViewController?.reload();
            });

    // Initialize the webview
    // Initialize the local notification plugin
    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> downloadFile(String url, String filename) async {
    try {
      await FileDownloader.downloadFile(
        url: url,
        name: filename,
        onProgress: (String? fileName, double? progress) {
          if (fileName != null && progress != null) {
            print('FILE $fileName HAS PROGRESS $progress');
            showDownloadNotification(fileName, progress.toInt());

          }
        },
        onDownloadCompleted: (String? path) {
          if (path != null) {
            print('FILE DOWNLOADED TO PATH: $path');
            flutterLocalNotificationsPlugin.cancel(0);

          }
        },
        onDownloadError: (String? error) {
          if (error != null) {
            print('DOWNLOAD ERROR: $error');
            flutterLocalNotificationsPlugin.cancel(0);
          }
        },
      );
    } catch (e) {
      print('Error downloading file: $e');
    }
  }
  Future<void> showDownloadNotification(String fileName, int progress) async {
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
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Downloading File',
      fileName,
      platformChannelSpecifics,
      payload: fileName,
    );
  }



  void _clearCache(BuildContext context) async {
    //store the navigator instance in a local variable
    final navigator = Navigator.of(context);
    //show confirmation dialog
    DefaultCacheManager().emptyCache();
    //use the navigator variable instead of context for navigation
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const DashboarddPage()),
      (route) => false,
    );

    //ToastNotification Files
    toastification.show(
      context: context,
      title: 'Everything Cleared',
      autoCloseDuration: const Duration(seconds: 3),
      icon: const Icon(Icons.check),
      backgroundColor: Colors.blueGrey,
      foregroundColor: Colors.white,
    );

    //ToastNotification Ends Here
  }

  @override
  Widget build(BuildContext context) {
    final searchUrl = 'https://duckduckgo.com/?q=${widget.query}';
    return WillPopScope(
      //Backpress Starts
      onWillPop: () async {
        if (await webViewController!.canGoBack()) {
          webViewController!.goBack();
          return false;
        } else {
          return true;
        }
      },

      //Backpress Ends
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.blueGrey, Colors.black87])),
                child: TextField(
                    decoration: InputDecoration(
                      //Search Bar Prefix Icon
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          webViewController?.reload();
                        },
                      ),

                      //Search Bar Suffix icon
                      suffixIcon: IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.cleaning_services),
                        onPressed: () => _clearCache(context),
                      ),
                    ),
                    //Search Bar Text Field Starts Here
                    textAlign: TextAlign.center,
                    controller: urlController,
                    keyboardType: TextInputType.url,
                    onSubmitted: (value) {
                      webViewController?.loadUrl(
                          urlRequest: URLRequest(url: WebUri(searchUrl)));
                    }),
              ),

              //Search Bar Text Field End Here
              Expanded(
                child: Stack(children: [
                  InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(url: WebUri(searchUrl)),
                    initialSettings: settings,
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (InAppWebViewController controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onPermissionRequest: (controller, request) async {
                      return PermissionResponse(
                          resources: request.resources,
                          action: PermissionResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;
                      if (![
                        "http",
                        "https",
                        "file",
                        "chrome",
                        "data",
                        "javascript",
                        "about"
                      ].contains(uri.scheme)) {
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                          );
                          return NavigationActionPolicy.CANCEL;
                        }
                      }
                      return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) async {
                      pullToRefreshController?.endRefreshing();
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onReceivedError: (controller, request, error) {
                      pullToRefreshController?.endRefreshing();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController?.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                        urlController.text = url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },

                    //Download Logic Starts Here

                    onDownloadStartRequest: (controller, urlRequest) async {
                      final url = urlRequest.url.toString();
                      final filename = url.substring(url.lastIndexOf('/') + 1);
                      await downloadFile(url, filename);
                    },

                    //Download Logic Ends Here
                  ),
                  progress < 1.0
                      ? LinearProgressIndicator(
                          value: progress,
                          color: Colors.deepOrangeAccent,
                        )
                      : Container(),
                ]),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () async {
                    if (await webViewController!.canGoBack()) {
                      webViewController!.goBack();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    webViewController?.reload();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () async {
                    if (await webViewController!.canGoForward()) {
                      webViewController!.goForward();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
