import UIKit
import Flutter
import SafariServices

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var result: FlutterResult?
    var safariViewController: SFSafariViewController?
    var channel: FlutterMethodChannel?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
     channel = FlutterMethodChannel(name: "com.karthick.dropboxClientsManager/dropoboxClientManager",
                                              binaryMessenger: controller.binaryMessenger)
    
    channel?.setMethodCallHandler({
               [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
               self?.result = result
        guard let arguments = call.arguments as? [String: String],
            let urlString = arguments["url"],
            let url = URL(string: urlString) else {
            result("Url not found")
            return
        }
       switch call.method {
       case "openInAppBrowser":
        self?.safariViewController = SFSafariViewController(url: url)
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController,
            let safariViewController = self?.safariViewController {
            rootViewController.present(safariViewController, animated: true, completion: nil)
        }
       case "canOpenUrl":
        let canOpenUrl = UIApplication.shared.canOpenURL(url)
        result(["canOpenUrlResult": canOpenUrl])
       case "openUrl":
        UIApplication.shared.open(url)
       default :
           result(FlutterMethodNotImplemented)
       }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let result = result {
            result(["responseUrl": url.absoluteString])
        }
        channel?.invokeMethod("responseUrl", arguments: url.absoluteString)
        safariViewController?.dismiss(animated: true)
        return true
    }
}
