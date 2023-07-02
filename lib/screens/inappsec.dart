import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nothing_browser/screens/dash.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:toastification/toastification.dart';
import 'package:dio/dio.dart';


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

  );

  //Refresh Page Circule432r Progress bar
  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  String? downloadUrl; // Stores the download URL //ChatGPTCode1
  bool isDownloadable = false; // Indicates if the current page has a downloadable resource

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
    // Initialize the download button color
    updateDownloadButtonColor(false); //ChatGPTCode1
  }
  //ChatGPTCode1
  void updateDownloadButtonColor(bool isDownloadable) {
    setState(() {
      this.isDownloadable = isDownloadable;
    });
  }

  Future<void> _onDownloadPressed() async {
    if (downloadUrl != null) {
      // Decode the URL to handle special characters
      final decodedUrl = Uri.decodeComponent(downloadUrl!);
      final uri = Uri.parse(decodedUrl);
      final baseUrl = '${uri.scheme}://${uri.host}${uri.path}';
      final HttpClient httpClient = HttpClient();
      final HttpClientRequest request = await httpClient.getUrl(uri);
      final HttpClientResponse response = await request.close();

      // Extract the file name from the response headers
      final contentDispositionHeader = response.headers.value('content-disposition');
      String fileName = '';
      if (contentDispositionHeader != null) {
        final regex = RegExp('filename=[\'"]?([^\'"s]+)');
        final matches = regex.allMatches(contentDispositionHeader);
        if (matches.isNotEmpty) {
          final match = matches.first;
          fileName = match.group(1) ?? '';
        }
      }

      // File name and path where the downloaded file will be saved
      String savePath = "/storage/emulated/0/Download/$fileName"; // Replace with the desired save path and include the file name

      try {
        Dio dio = Dio();
        await dio.download(baseUrl, savePath);

        // Show a success message or perform other actions after successful download
        toastification.show(
          context: context,
          title: 'Download completed!',
          autoCloseDuration: const Duration(seconds: 3),
          icon: const Icon(Icons.check),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        );
      } catch (e) {
        // Handle any download errors
        toastification.show(
          context: context,
          title: 'Download failed!',
          autoCloseDuration: const Duration(seconds: 3),
          icon: const Icon(Icons.error),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        );
        print("Error downloading file: $e");
      }
    }
  }



  //ChatGPTCode12



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
                    color: Colors.white,
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      // push the download screen using a navigator widget

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
                  onDownloadStartRequest: (controller, url) {
                    setState(() {
                      downloadUrl = url.toString();
                      updateDownloadButtonColor(true);
                    }
                    );
                  }
                ),
                progress < 1.0
                    ? LinearProgressIndicator(value: progress,
                color: Colors.deepOrangeAccent,
                )
                    : Container(),
                if (isDownloadable)
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    color: Colors.black,
                    child: ElevatedButton(
                      onPressed: _onDownloadPressed,
                      child: const Text('Download File'),
                    ),
                  )
              ],
            )
            )
            //Body Ends Here
          ],
        )
        ),

        //ChatGPTCode1 can Safely Delete
        floatingActionButton: FloatingActionButton(
          onPressed: isDownloadable ? _onDownloadPressed : null,
          child: Icon(
            Icons.download,
            color: isDownloadable ? Colors.red : null,
          ),


        ),

        //ChatGPTCode1 can Safely Delete End



      ),
    );
  }
}
