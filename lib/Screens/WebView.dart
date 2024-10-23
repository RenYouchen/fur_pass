import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  static const platform = MethodChannel('com.renyouchen.furPass/webView');

  Future<void> _openWebView(String url) async {
    try {
      await platform.invokeMethod('openWebView', {'url': url});
    } on PlatformException catch (e) {
      // 处理异常
      print("Failed to open WebView: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments as String;
    _openWebView(data).then((_) {
      Navigator.pop(context);
    });
    return Placeholder();
  }
}
