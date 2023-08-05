package digital.taranila.nothing_browser

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel



class MainActivity : FlutterActivity() {
    private val CHANNEL = "HiChannel" // Match the channel name in Dart code

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val context = this   // Obtain the Context associated with the activity

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "launchIntent") {
                val uriString = call.arguments.toString()
                try {
                    val intent = Intent.parseUri(uriString, Intent.URI_INTENT_SCHEME)
                    context.startActivity(intent)  // Call startActivity using the obtained Context
                    result.success("success")
                } catch (e: Exception) {
                    result.error("Error", "Failed to launch intent", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}


