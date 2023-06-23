package digital.taranila.nothing_browser

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.flutter_downloader.FlutterDownloaderPlugin


class MainActivity: FlutterActivity() {
    fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FlutterDownloaderPlugin.registerWith(registrarFor(FlutterDownloaderPlugin::class.java.name))
    }
}
