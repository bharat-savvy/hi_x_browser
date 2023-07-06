import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nothing_browser/parts/download_helper.dart';
import 'package:nothing_browser/websitedetails/websitedata.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nothing_browser/parts/header.dart';

class DuckDuckSearchPage extends StatefulWidget {
  final String query;
  final int index;




  const DuckDuckSearchPage({Key? key, required this.query, required this.index}) : super(key: key);

  @override
  State<DuckDuckSearchPage> createState() => _DuckDuckSearchPageState();
}

class _DuckDuckSearchPageState extends State<DuckDuckSearchPage> {
  final GlobalKey webViewKey = GlobalKey();



  //AdBlocking Ends Here

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
    userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',


  );

//Refresh Page Circuler Progress bar
  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  List<String> windows = []; // List to store window URLs


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      List<String> webpages1 = [];



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

    // If the query is a URL, load it directly
    if (widget.query.startsWith('http://') || widget.query.startsWith('https://')) {
      url = widget.query;
    } else {
      url = 'https://duckduckgo.com/?q=${widget.query}';
    }

    // Initialize the webview
    webpages1 = List.from(websiteData['webpages1']!);

    // Initialize the local notification plugin
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
      throw 'Could not launch Whatsapp';
    }
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
              HeaderPage(
                  controller: urlController,

                onSubmitted: (value) {
                  if (value.startsWith('http://') || value.startsWith('https://')) {
                    // If the entered value starts with 'http://' or 'https://',
                    // treat it as a URL and open it in DuckDuckGoSearchPage
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DuckDuckSearchPage(query: widget.query, index: widget.index),
                      ),
                    );
                  } else {
                    // Otherwise, treat it as a search query and perform the search
                    String searchUrl = '${webpages1[widget.index]}=$value';
                    webViewController?.loadUrl(
                      urlRequest: URLRequest(
                        url: WebUri(searchUrl),
                      ),
                    );
                  }
                },

              ),

              //Search Bar Text Field End Here
              Expanded(
                child: Stack(children: [
                  InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(url: WebUri(searchUrl)),
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
                          // Handle Google Play app links
                          var packageName = uri.queryParameters['id'];
                          if (packageName != null) {
                            launchGooglePlayLink(packageName);
                            return NavigationActionPolicy.CANCEL;
                          }
                        }

                        else if (uri.scheme == 'whatsapp') {
                          // Handle WhatsApp product catalog links
                          var phoneNumber = uri.queryParameters['phoneNumber'];
                          if (phoneNumber != null) {
                            openWhatsAppProductCatalogPrime(phoneNumber);
                            return NavigationActionPolicy.CANCEL;
                          }
                        }


                        else if (uri.scheme == 'whatsapp') {
                          // Handle WhatsApp product catalog links
                          var niyaz = uri.queryParameters['mobileNumber'];
                          if (niyaz != null) {
                            openWhatsApp(niyaz);
                            return NavigationActionPolicy.CANCEL;
                          }
                        }


                        else {
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

                    //Download Logic Starts Here

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

        ),
      ),
    );
  }
}


