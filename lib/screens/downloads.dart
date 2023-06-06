import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

// create a stateful widget for the download screen
class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  _DownloadScreenState createState() {
    return _DownloadScreenState();
  }
}

// create a state class for the download screen
class _DownloadScreenState extends State<DownloadScreen> {
  // declare a variable to store the list of download tasks
  List<DownloadTask>? _tasks;

  // override the initState method to initialize the download tasks
  @override
  void initState() {
    super.initState();
    // get the list of download tasks from the flutter_downloader plugin
    FlutterDownloader.loadTasks().then((tasks) {
      setState(() {
        _tasks = tasks;
      });
    });
  }

  // create a method to clear all downloads
  // create a method to clear all downloads
  void _clearAllDownloads() async {
    // get the list of download tasks from the flutter_downloader plugin
    List<DownloadTask>? tasks = await FlutterDownloader.loadTasks();
    // loop through each download task
    for (DownloadTask task in tasks!) {
      // cancel the download task
      FlutterDownloader.cancel(taskId: task.taskId);
      // delete the downloaded file if it exists
      File file = File('${task.savedDir}/${task.filename ?? 'Unknown'}');
      if (file.existsSync()) {
        file.deleteSync();
      }
      // delete the download task from the flutter_downloader plugin
      FlutterDownloader.remove(taskId: task.taskId, shouldDeleteContent: true);
    }
    // update the state of the download screen
    setState(() {
      _tasks = [];
    });
  }


  // override the build method to return a widget for the download screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        // add an action icon to clear all downloads
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // call the _clearAllDownloads method
              _clearAllDownloads();
            },
          ),
        ],
      ),
      body: _tasks == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _tasks!.length,
        itemBuilder: (context, index) {
          // get the current download task
          DownloadTask task = _tasks![index];
          // return a list tile widget for each download task
          return ListTile(
            leading: const Icon(Icons.file_download),
            title: Text(task.filename ?? 'Unknown'),
            subtitle: Text('${task.progress}%'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // add an icon button to pause or resume the download task
                IconButton(
                  icon: task.status == DownloadTaskStatus.running
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow),
                  onPressed: () {
                    // check the status of the download task
                    if (task.status == DownloadTaskStatus.running) {
                      // pause the download task
                      FlutterDownloader.pause(taskId: task.taskId);
                    } else if (task.status == DownloadTaskStatus.paused) {
                      // resume the download task
                      FlutterDownloader.resume(taskId: task.taskId);
                    }
                  },
                ),
                // add an icon button to cancel the download task
                IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    // cancel the download task
                    FlutterDownloader.cancel(taskId: task.taskId);
                  },
                ),
                // add an icon button to open the downloaded file
                IconButton(
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () {
                    // check if the download task is completed
                    if (task.status == DownloadTaskStatus.complete) {
                      // open the downloaded file using the open_file plugin
                      OpenFile.open('${task.savedDir}/${task.filename ?? 'Unknown'}');
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
