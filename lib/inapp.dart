import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nothing_browser/dashboard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:toastification/toastification.dart';

class InAppWebViewPage extends StatefulWidget {
  final int index;

  const InAppWebViewPage({super.key, required this.index});

  @override
  State<InAppWebViewPage> createState() {
    return _InAppWebViewPageState();
  }
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  final GlobalKey webViewKey = GlobalKey();

  //InAppWebView Settings//
  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true,
      useOnDownloadStart: true

  );


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
    toastification.show(
      context: context,
      title: 'Everything Cleared',
      autoCloseDuration: const Duration(seconds: 3),
      icon: const Icon(Icons.check),
      backgroundColor: Colors.blueGrey,
      foregroundColor: Colors.white,
    );


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
                          colors: [
                            Colors.blueGrey,
                            Colors.black87
                          ]

                      )
                  ),
                  child: TextField(
                    decoration: InputDecoration(

                      //Search Bar Prefix Icon
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.add_box_outlined),
                        onPressed: (){
                        },),


                      //Search Bar Suffix icon
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.cleaning_services),
                        onPressed: ()=> _onPressed(context),
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
