import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nothing_browser/dashboard.dart';
import 'package:nothing_browser/screens/downloads.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:toastification/toastification.dart';
// import the flutter_downloader plugin
import 'package:flutter_downloader/flutter_downloader.dart';
// import the path_provider plugin
import 'package:path_provider/path_provider.dart';
// import the permission_handler plugin
import 'package:permission_handler/permission_handler.dart';

class DashedPage extends StatefulWidget {
  final int index;

  const DashedPage({Key? key, required this.index}) : super(key: key);

  @override
  State<DashedPage> createState() => _DashedPageState();
}

class _DashedPageState extends State<DashedPage> {
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
      useOnDownloadStart: true);

  //Refresh Page Circuler Progress bar
  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(color: Colors.blue),
            onRefresh: () async {
              defaultTargetPlatform == TargetPlatform.android;
              webViewController?.reload();
            });
    // initialize the flutter_downloader plugin
    FlutterDownloader.initialize(debug: true);
  }

  void _onPressed(BuildContext context) async {
    //store the navigator instance in a local variable
    final navigator = Navigator.of(context);
    //show confirmation dialog
    DefaultCacheManager().emptyCache();
    //use the navigator variable instead of context for navigation
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const DashboardPage()),
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

  // A list of webpages to load for each button
  final List<String> webpages = [
    'https://start.duckduckgo.com/',
    'https://www.google.com/',
    'https://www.bing.com/',
    'https://www.yahoo.com/',
    'https://yandex.com/',
    'https://startpage.com/',
    'https://www.ask.com/',
    'https://www.ecosia.org/',
    'https://www.wolframalpha.com/',
    'https://search.aol.com/',
  ];

  //A List of Webpages 2 for top search bar
  final List<String> webpages1 = [
    "https://duckduckgo.com/?q",
    "https://www.google.com/search?q",
    "https://www.bing.com/search?q",
    "https://search.yahoo.com/search?q",
    "https://yandex.com/search/touch/?text",
    "https://startpage.com/search?q",
    "https://www.ask.com/web?q",
    "https://www.ecosia.com/search?method=index&q",
    "https://www.wolframalpha.com/input?i",
    "https://search.aol.com/aol/search?q",
  ];

  @override
  Widget build(BuildContext context) {
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

      child: Scaffold(
        body: SafeArea(
            child: Column(
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
                    icon: const Icon(Icons.add_box_outlined),
                    onPressed: () {
                      // push the download screen using a navigator widget
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DownloadScreen()),
                      );
                    },
                  ),

                  //Search Bar Suffix icon
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cleaning_services),
                    onPressed: () => _onPressed(context),
                  ),
                ),

                //Search Bar Text Field Starts Here
                textAlign: TextAlign.center,
                controller: urlController,
                keyboardType: TextInputType.url,
                onSubmitted: (value) {
                  switch (widget.index) {
                    case 0: // DuckDuckGo
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri(webpages1[0] + "=$value"),
                        ),
                      );
                      break;
                    case 1: // Google
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri(webpages1[1] + "=$value"),
                        ),
                      );
                      break;
                    case 2: // Bing
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri(webpages1[2] + "=$value"),
                        ),
                      );
                      break;

                    case 3: // Yahoo
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri(webpages1[3] + "=$value"),
                        ),
                      );
                      break;

                    case 4: // Yandex
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri(webpages1[4] + "=$value"),
                        ),
                      );
                      break;

                    case 5: // StartPage
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri(webpages1[5] + "=$value"),
                        ),
                      );
                      break;

                    case 6: // Ask
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri(webpages1[6] + "=$value"),
                        ),
                      );
                      break;

                    case 7: // Ecosia
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri(webpages1[7] + "=$value"),
                        ),
                      );
                      break;

                    case 8: // WolFarm
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri(webpages1[8] + "=$value"),
                        ),
                      );
                      break;

                    case 9: // Aol
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri(webpages1[9] + "=$value"),
                        ),
                      );
                      break;

                    // and so on for the other cases
                  }
                },
              ),
            ),

            //Search Bar Text Field End Here

            //Body Starts Here
            Expanded(
                child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  initialUrlRequest:
                      URLRequest(url: WebUri(webpages[widget.index])),
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
                  // add the onDownloadStart event handler with permission check and download task enqueueing
                  // add the onDownloadStartRequest event handler with permission check and download task enqueueing
                  // add the onDownloadStartRequest event handler with permission check and download task enqueueing
                  onDownloadStartRequest: (controller, downloadUrl) async {
                    print("onDownloadStart $downloadUrl");

                    // check and request storage permission
                    var status = await Permission.storage.status;
                    if (!status.isGranted) {
                      status = await Permission.storage.request();
                    }
                    if (status.isGranted) {
                      final dir = await getExternalStorageDirectory();
                      var _localPath =
                          dir!.path + Platform.pathSeparator + 'Download';
                      final savedDir = Directory(_localPath);
                      await savedDir
                          .create(recursive: true)
                          .then((value) async {
                        Uri uri = Uri.parse(downloadUrl.toString().substring(downloadUrl.toString().indexOf("url:") + 5)); // extract the URL part and parse it
                        // use FlutterDownloader.enqueue() instead of http.get()
                        String? _taskid = await FlutterDownloader.enqueue(
                          url: uri.toString(),
                          savedDir: _localPath,
                          showNotification: true,
                          openFileFromNotification: true,
                          saveInPublicStorage: true,
                        );
                        print(_taskid);
                        // store the _taskid in a variable or a list for later use
                      });
                    } else {
                      print("Permission denied");
                      // show a message that permission is denied
                    }
                  },

                ),
                progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container(),
              ],
            ))
            //Body Ends Here
          ],
        )),
      ),
    );
  }
}
