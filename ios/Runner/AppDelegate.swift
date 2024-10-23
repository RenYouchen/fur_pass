import Flutter
import SafariServices
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate{
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
// MARK: - Flutter Channel
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let webViewChannel = FlutterMethodChannel(name: "com.renyouchen.furPass/webView", binaryMessenger: controller.binaryMessenger)
    
      webViewChannel.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: FlutterResult) in
          if(call.method == "openWebView") {
              guard let args = call.arguments as? [String: Any],
                    let url = args["url"] as? String else {
                  result(FlutterError(code: "Invaild arg", message: "Missing url", details: nil))
                  return
              }
              self?.openUrl(url: url, controller: controller)
              result(nil)
          } else {
              result(FlutterMethodNotImplemented)
          }
          
      })
      
// MARK: - generate code
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
// MARK: - openWebview
    private func openUrl(url: String, controller: FlutterViewController) {
        let safariViewController = SFSafariViewController(url: URL(string: url)!)
        controller.present(safariViewController, animated: true, completion: nil)
    }
}

