import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nothing_browser/dashboard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:toastification/toastification.dart';


class WolfarmPage extends StatefulWidget {
  const WolfarmPage({Key? key}) : super(key: key);

  @override
  State<WolfarmPage> createState() => _WolfarmPageState();
}

class _WolfarmPageState extends State<WolfarmPage> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

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
                TextField(
                  decoration: InputDecoration(

                    //Search Bar Prefix Icon
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.home),
                      onPressed: () {
                        Navigator.pushNamed(context, '/wolfarmd');
                      } ,),


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
                    var url = WebUri(value);
                    if (url.scheme.isEmpty) {
                      url = WebUri("https://www.wolframalpha.com/input?i=$value");
                    }
                    webViewController?.loadUrl(urlRequest: URLRequest(url: url));
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
                          URLRequest(url: WebUri("https://www.wolframalpha.com/")),
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





