import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nothing_browser/screens/dash.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

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
  );


//Refresh Page Circuler Progress bar
  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();


  //ChatGPT CODE Starts Here
  List<String> navigationHistory = [];
  //ChatGPT Code Ends Here


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
  }

  void _onPressed(BuildContext context) async {
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



  //ChatGPT Code Can Be delete



  Future<void> downloadFile(String url) async {
    final directory = await getApplicationDocumentsDirectory();
    final savedDir = directory.path;
    await FlutterDownloader.enqueue(
      url: url,
      savedDir: savedDir,
      showNotification: true,
      openFileFromNotification: true,
    );
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
                        onPressed: () => _onPressed(context),
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
                    onDownloadStartRequest: (controller, download) async {
                      final DownloadStartRequest request = download;
                      final String url = request.url.toString();
                      downloadFile(url);
                    },

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