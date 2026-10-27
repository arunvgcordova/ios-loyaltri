import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let channelName = "app.security/checks"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  UIDevice.current.isBatteryMonitoringEnabled = true
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }
    GMSServices.provideAPIKey("AIzaSyBBbVFdC9pf_Tu0p2eLQwyo3dGtvL1thCA")
    UNUserNotificationCenter.current().delegate = self

    // Set up the Flutter security channel safely (window can be nil during background location wake)
    if let controller = window?.rootViewController as? FlutterViewController {
      let securityChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)
      securityChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
        switch call.method {
          case "detectFrida":
            result(self.detectFrida())
          case "isDebuggerConnected":
            result(self.isDebuggerAttached())
          case "isDeviceRooted":
            result(self.isDeviceJailbroken())
          default:
            result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Handle implicit Flutter engine registration for UIScene / background wake-ups
  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  // Push notification display customization
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.banner, .sound, .badge])
  }

  // Clear badge when app becomes active
  override func applicationDidBecomeActive(_ application: UIApplication) {
  UIDevice.current.isBatteryMonitoringEnabled = true
    application.applicationIconBadgeNumber = 0
    super.applicationDidBecomeActive(application)
  }

  // MARK: - Security Check Methods

  private func isDebuggerAttached() -> Bool {
    return isatty(STDERR_FILENO) != 0
  }

  private func detectFrida() -> Bool {
    let fridaIndicators = ["/usr/sbin/frida-server", "/usr/bin/frida-server"]
    for path in fridaIndicators {
      if FileManager.default.fileExists(atPath: path) {
        return true
      }
    }
    return false
  }

  private func isDeviceJailbroken() -> Bool {
    let paths = [
      "/Applications/Cydia.app",
      "/Library/MobileSubstrate/MobileSubstrate.dylib",
      "/bin/bash",
      "/usr/sbin/sshd",
      "/etc/apt"
    ]
    for path in paths {
      if FileManager.default.fileExists(atPath: path) {
        return true
      }
    }

    // Check if you can write outside sandbox (extra jailbreak check)
    let testWrite = "/private/jailbreak.txt"
    do {
      try "Jailbreak Test".write(toFile: testWrite, atomically: true, encoding: .utf8)
      try FileManager.default.removeItem(atPath: testWrite)
      return true
    } catch {
      return false
    }
  }
}
