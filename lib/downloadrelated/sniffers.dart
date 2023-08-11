import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import 'package:logger/logger.dart';

class VideoSniffer {
  final InAppWebViewController? webViewController;
  final BuildContext context;
  final Logger _logger = Logger();

  VideoSniffer({
    required this.webViewController,
    required this.context,
  });

  Future<void> setupDOMObserver() async {
    try {
      webViewController!.addJavaScriptHandler(
        handlerName: 'observeDOMChanges',
        callback: (_) {
          sniffVideos();
        },
      );

      await webViewController!.evaluateJavascript(source: '''
        var observer = new MutationObserver(function(mutations) {
          window.flutter_inappwebview.callHandler('observeDOMChanges');
        });
        observer.observe(document, { childList: true, subtree: true });
      ''');
    } catch (e) {
      _logger.e('Error setting up DOM observer: $e');
    }
  }

  Future<void> sniffVideos() async {
    if (webViewController != null) {
      try {
        // Evaluate JavaScript code in the webview to extract video data (URLs and titles)
        final videoData =
            await webViewController!.evaluateJavascript(source: '''
            function extractVideoData() {
              var videoData = [];
  
              // Detect videos in <video> elements
              var videos = document.querySelectorAll('video');
              videos.forEach(function(video) {
                if (video.currentSrc) {
                  var title = video.title || video.getAttribute('alt') || '';
                  var duration = video.duration; // Duration in seconds
                  var resolution = video.videoWidth + 'x' + video.videoHeight; // Resolution
                  videoData.push({ url: video.currentSrc, title: title, duration: duration, resolution: resolution });
                }
                // ...
              });

  
              // Detect videos in <source> elements within <video> elements
              var videoSources = document.querySelectorAll('video source');
              videoSources.forEach(function(source) {
                var src = source.src;
                if (isVideoFormatSupported(src)) {
                  videoData.push({ url: src, title: '' });
                }
              });
  
              // Detect videos in <iframe> elements
              var iframes = document.querySelectorAll('iframe');
              iframes.forEach(function(iframe) {
                var src = iframe.src;
                if (src.includes('youtube.com') || src.includes('vimeo.com') || src.includes('dailymotion.com')) {
                  videoData.push({ url: src, title: '' });
                }
              });
              
              // Detect Facebook videos in <div> elements
              var facebookDivs = document.querySelectorAll('.fb-video'); // Customize this selector
                facebookDivs.forEach(function(div) {
                 var videoUrl = div.getAttribute('data-href'); // Customize this attribute
                 if (videoUrl) {
                 videoData.push({ url: videoUrl, title: '' });
                  }
                  });
  
              // Detect Instagram videos in <a> elements
                var instagramLinks = document.querySelectorAll('a'); // Customize this selector
                  instagramLinks.forEach(function(link) {
                    var href = link.getAttribute('href');
                    if (href && (href.includes('instagram.com/p/') || href.includes('instagram.com/tv/'))) {
               videoData.push({ url: href, title: '' });
                 }
               });
  
  
              
              
              
              // Detect videos in <embed> elements
              var embeds = document.querySelectorAll('embed');
              embeds.forEach(function(embed) {
                var src = embed.src;
                if (isVideoFormatSupported(src)) {
                  videoData.push({ url: src, title: '' });
                }
              });
  
              // Detect videos in <object> elements
              var objects = document.querySelectorAll('object');
              objects.forEach(function(object) {
                var param = object.querySelector('param[name="movie"]');
                if (param) {
                  var src = param.value;
                  if (isVideoFormatSupported(src)) {
                    videoData.push({ url: src, title: '' });
                  }
                }
              });
  
              // Detect videos in .html elements
              var htmlElements = document.querySelectorAll('.html'); // Change to match your actual class or element
              htmlElements.forEach(function(element) {
                var videoUrl = element.getAttribute('data-video-url');
                if (videoUrl) {
                  videoData.push({ url: videoUrl, title: '' });
                }
                var videoUrlFromInnerHtml = element.innerHTML;
                if (videoUrlFromInnerHtml) {
                  videoData.push({ url: videoUrlFromInnerHtml, title: '' });
                }
              });
              
              
              // Detect videos in <div> elements
              var divs = document.querySelectorAll('div'); // Customize this selector
              divs.forEach(function(div) {
              var videoUrl = div.getAttribute('data-video-url'); // Customize this attribute
              if (videoUrl && isVideoFormatSupported(videoUrl)) {
                videoData.push({ url: videoUrl, title: '' });
              }
            });
  
              return videoData;
            }
  
            function isVideoFormatSupported(url) {
              var supportedFormats = ['.mp4', '.webm', '.avi', '.mov', '.mpg'];
              return supportedFormats.some(format => url.toLowerCase().endsWith(format));
            }
  
            JSON.stringify(extractVideoData());
          ''');

        // Parse the extracted video data (URLs and titles)
        final parsedData = (json.decode(videoData) as List<dynamic>)
            .cast<Map<String, dynamic>>();

        if (parsedData.isNotEmpty) {
          _showVideoTitlesDialog(parsedData);
        } else {
          _showNoVideoTitlesDialog();
        }
      } catch (e) {
        _showErrorDialog('Error sniffing videos: $e');
      }
    }
  }

  Future<void> _downloadVideo(String url) async {
    try {
      await FileDownloader.downloadFile(
        url: url,
        onProgress: (String? fileName, double? progress) {
          if (fileName != null && progress != null) {
            _logger.d('FILE $fileName HAS PROGRESS $progress');
          }
        },
        onDownloadCompleted: (String? path) {
          if (path != null) {
            _logger.d('FILE DOWNLOADED TO PATH: $path');
          }
        },
        onDownloadError: (String? error) {
          if (error != null) {
            _logger.e('DOWNLOAD ERROR: $error');
          }
        },
      );
    } catch (e) {
      _logger.e('Error downloading file: $e');
    }
  }

  void _showVideoTitlesDialog(List<Map<String, dynamic>> parsedData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Download Videos'),
          content: ListView.builder(
            itemCount: parsedData.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  parsedData[index]['title'],
                  style: GoogleFonts.lato(fontSize: 10),
                ),
                subtitle: SelectableText(
                    parsedData[index]['url'],
                    style: GoogleFonts.lato(fontSize: 10),
                  ),

                leading: IconButton(
                  icon: const Icon(Icons.download),
                  color: Colors.red,
                  onPressed: () {
                    _logger.e('Download icon pressed'); // Add this line

                    _downloadVideo(
                      parsedData[index]['url'],
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showNoVideoTitlesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'No Videos Found',
            style: GoogleFonts.lato(fontSize: 15, color: Colors.red),
          ),
          content: Text(
            "Dear User,\n\n"
            "If you think the result is incorrect, please be advised that our video sniffer might not be operating at full capacity yet. In certain instances, it could present inaccurate outcomes. Rest assured, we are diligently working on enhancing its capabilities, and any inconsistencies will be rectified in forthcoming updates. We greatly appreciate your patience and understanding.\n\n"
            "Best regards,",
            style: GoogleFonts.lato(fontSize: 12),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget buildFloatingActionButton() {
    return SizedBox(
      height: 40,
      width: 40,
      child: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          sniffVideos();
        },
        child: const Icon(
          Icons.download,
          color: Colors.white,
        ),
      ),
    );
  }
}
