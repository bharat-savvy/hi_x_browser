import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nothing_browser/parts/header.dart';
import 'package:nothing_browser/websitedetails/websitedata.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nothing_browser/parts/download_helper.dart';

class AllAppSearchPage extends StatefulWidget {
  final int index;

  const AllAppSearchPage({Key? key, required this.index}) : super(key: key);

  @override
  State<AllAppSearchPage> createState() => _AllAppSearchPageState();
}

class _AllAppSearchPageState extends State<AllAppSearchPage> {
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

  //Refresh Page Circule432r Progress bar
  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  List<String> webpages = websiteData['webpages']!;
  List<String> webpages1 = websiteData['webpages1']!;
  List<String> webpages2 = websiteData['webpages2']!;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
      settings: PullToRefreshSettings(color: Colors.green.withOpacity(0.5)),
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          webViewController?.reload();
        }
      },
    );

    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> downloadFile(String url, String filename) async {
    await DownloadHelper.downloadFile(url, filename, (fileName, progress) {
      showDownloadNotification(fileName, progress.toInt());
    });
  }

  Future<void> showDownloadNotification(String fileName, int progress) async {
    await NotificationHelper.showDownloadNotification(fileName, progress);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await webViewController!.canGoBack()) {
          webViewController!.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              HeaderPage(
                controller: urlController,
                onSubmitted: (value) {
                  final index = widget.index;
                  if (index >= 0 && index < webpages1.length) {
                    webViewController?.loadUrl(
                      urlRequest: URLRequest(
                        url: WebUri("${webpages1[index]}=$value"),
                      ),
                    );
                  }
                },
              ),

              Expanded(
                child: Stack(
                  children: [
                    Hero(
                      tag: 'image${widget.index}',
                      child: InAppWebView(
                        key: webViewKey,
                        initialUrlRequest: URLRequest(url: WebUri(webpages[widget.index])),
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
                            action: PermissionResponseAction.GRANT,
                          );
                        },
                        shouldOverrideUrlLoading: (controller, navigationAction) async {
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
                              await launchUrl(uri);
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
                        onDownloadStartRequest: (controller, urlRequest) async {
                          final url = urlRequest.url.toString();
                          final filename = url.substring(url.lastIndexOf('/') + 1);
                          await downloadFile(url, filename);
                        },
                      ),
                    ),
                    progress < 1.0
                        ? LinearProgressIndicator(
                      value: progress,
                      color: Colors.green.withOpacity(0.3),
                    )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
