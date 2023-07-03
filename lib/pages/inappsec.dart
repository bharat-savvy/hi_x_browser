import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nothing_browser/parts/duck_header.dart';
import 'package:nothing_browser/websitedetails/websitedata.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nothing_browser/parts/download_helper.dart';



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
  String? downloadUrl; // Stores the download URL //ChatGPTCode1

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  List<String> webpages = [];
  List<String> webpages1 = [];

  //scroll hidden implementation

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(color: Colors.green.withOpacity(0.5)),
            onRefresh: () async {
              defaultTargetPlatform == TargetPlatform.android;
              webViewController?.reload();
            });

    webpages = List.from(websiteData['webpages']!);
    webpages1 = List.from(websiteData['webpages1']!);

    // Initialize the download button color

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

  //ChatGPTCode12



    //ToastNotification Ends Here


  // A list of webpages to load for each button

  //ChatGPT Download COde

  //ChatGPT COde End

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
            SearchBarPage(
              controller: urlController,
              onSubmitted: (value) {
                  switch (widget.index) {
                    case 0: // DuckDuckGo
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri("${webpages1[0]}=$value"),
                        ),
                      );
                      break;
                    case 1: // Google
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri("${webpages1[1]}=$value"),
                        ),
                      );
                      break;
                    case 2: // Bing
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri("${webpages1[2]}=$value"),
                        ),
                      );
                      break;

                    case 3: // Yahoo
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri("${webpages1[3]}=$value"),
                        ),
                      );
                      break;

                    case 4: // Yandex
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri("${webpages1[4]}=$value"),
                        ),
                      );
                      break;

                    case 5: // StartPage
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri("${webpages1[5]}=$value"),
                        ),
                      );
                      break;

                    case 6: // Ask
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri("${webpages1[6]}=$value"),
                        ),
                      );
                      break;

                    case 7: // Ecosia
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri("${webpages1[7]}=$value"),
                        ),
                      );
                      break;

                    case 8: // WolFarm
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri("${webpages1[8]}=$value"),
                        ),
                      );
                      break;

                    case 9: // Aol
                      webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri("${webpages1[9]}=$value"),
                        ),
                      );
                      break;

                    // and so on for the other cases
                  }
                },
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
                    onDownloadStartRequest: (controller, urlRequest) async {
                      final url = urlRequest.url.toString();
                      final filename = url.substring(url.lastIndexOf('/') + 1);
                      await downloadFile(url, filename);
                    }



                    ),
                progress < 1.0
                    ? LinearProgressIndicator(
                        value: progress,
                        color: Colors.green.withOpacity(0.3),
                      )
                    : Container(),
              ],
            ))
            //Body Ends Here
          ],
        )),

        //ChatGPTCode1 can Safely Delete

        //ChatGPTCode1 can Safely Delete End
      ),
    );
  }
}
