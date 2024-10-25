package com.renyouchen.fur_pass

import android.net.Uri
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.browser.customtabs.CustomTabsIntent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.net.URL

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.renyouchen.furPass/webView";

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler{ call, result ->
//            Log.d("android",call.method)
            print(call.method)
            if(call.method.equals("openWebView")) {
                val url = call.argument<String>("url")
                openWebView(url?:"https://www.google.com")
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun openWebView(url: String) {
        CustomTabsIntent.Builder().build().launchUrl(context, Uri.parse(url))
    }

}
