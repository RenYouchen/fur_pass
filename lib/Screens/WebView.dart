import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  static const platform = MethodChannel('com.renyouchen.furPass/webView');
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
