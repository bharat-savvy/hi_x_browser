import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nothing_browser/parts/download_helper.dart';
import 'package:nothing_browser/websitedetails/websitedata.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nothing_browser/parts/header.dart';

class DuckDuckSearchPage extends StatefulWidget {
  final String query;
  final int index;

  const DuckDuckSearchPage({Key? key, required this.query, required this.index})
      : super(key: key);

  @override
  State<DuckDuckSearchPage> createState() => _DuckDuckSearchPageState();
}

class _DuckDuckSearchPageState extends State<DuckDuckSearchPage> {
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
    userAgent:
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',

  );

  //Refresh Page Circuler Progress bar
  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  List<String> webpages1 = websiteData['webpages1']!;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
      settings: PullToRefreshSettings(color: Colors.green.withOpacity(0.3)),
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          webViewController?.reload();
        }
      },
    );

    if (Uri.tryParse(widget.query)?.hasScheme == true) {
      url = widget.query;
    } else {
      // If query is not a URL, perform DuckDuckGo search
      url = 'https://duckduckgo.com/?q=${widget.query}';
    }

    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

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

  Future<void> launchGooglePlayLink(String packageName) async {
    var uri = Uri.parse('market://details?id=$packageName');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch Google Play link';
    }
  }

  Future<void> openWhatsAppProductCatalogPrime(String phoneNumber) async {
    var uri = Uri.parse('whatsapp://catalog/?phoneNumber=$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch Whatsapp';
    }
  }

  Future<void> openWhatsApp(String mobileNumber) async {
    var uri = Uri.parse('whatsapp://send/?phone=$mobileNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Couldnot launch Whatsapp';
    }
  }

  void refreshWebView() {
    webViewController!.reload();
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
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              HeaderPage(
                controller: urlController,

                onSubmitted: (value) {
                  if (value.startsWith('http://') || value.startsWith('https://')) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DuckDuckSearchPage(
                          query: widget.query,
                          index: widget.index,
                        ),
                      ),
                    );
                  } else {
                    String searchUrl = '${webpages1[widget.index]}=$value';
                    webViewController?.loadUrl(
                      urlRequest: URLRequest(
                        url: WebUri(searchUrl),
                      ),
                    );
                  }
                }, onRefresh: refreshWebView,
              ),
              Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest: URLRequest(url: WebUri(url)),
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
                          if (uri.scheme == 'market') {
                            var packageName = uri.queryParameters['id'];
                            if (packageName != null) {
                              launchGooglePlayLink(packageName);
                              return NavigationActionPolicy.CANCEL;
                            }
                          } else if (uri.scheme == 'whatsapp') {
                            var phoneNumber = uri.queryParameters['phoneNumber'];
                            if (phoneNumber != null) {
                              openWhatsAppProductCatalogPrime(phoneNumber);
                              return NavigationActionPolicy.CANCEL;
                            }
                          } else {
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                              return NavigationActionPolicy.CANCEL;
                            }
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
                      onCreateWindow: (controller, createWindowRequest) async {
                        await controller.loadUrl(
                          urlRequest: URLRequest(
                            url: createWindowRequest.request.url,
                            headers: {},
                          ),
                        );
                        return true;
                      },
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
