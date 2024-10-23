import Flutter
import WebKit
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
// MARK: - Flutter Channel
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let webViewChannel = FlutterMethodChannel(name: "com.renyouchen.furPass/webView", binaryMessenger: controller.binaryMessenger)
    
//      webViewChannel.invokeMethod(<#T##method: String##String#>, arguments: <#T##Any?#>)
      
// MARK: - generate code
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

//MARK: - WebKit
class WebViewController: UIViewController {
  var url: String?
  var webView: WKWebView!

  override func viewDidLoad() {
    super.viewDidLoad()
    webView = WKWebView(frame: self.view.frame)
    self.view.addSubview(webView)

    if let urlString = url, let url = URL(string: urlString) {
      webView.load(URLRequest(url: url))
    }
  }
}
