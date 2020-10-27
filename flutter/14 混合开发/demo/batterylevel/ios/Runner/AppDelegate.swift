import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // 实现获取电池信息的功能
    // 1.获取FlutterViewController
    let controller: FlutterViewController = window.rootViewController as! FlutterViewController;
    
    // 2.创建FlutterMethodChannel
    let channel = FlutterMethodChannel(name: "coderwhy.com/battery", binaryMessenger: controller.binaryMessenger);
    
    // 3.监听channel调用方法
    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
        // 1.判断当前是getBatteryInfo
        guard call.method == "getBatteryInfo" else {
            result(FlutterMethodNotImplemented);
            return;
        }
        
        // 2.获取电池的信息
        let device = UIDevice.current;
        device.isBatteryMonitoringEnabled = true;
        
        // 3.获取电量的信息
        if device.batteryState == UIDevice.BatteryState.unknown {
            result(1000)
        } else {
            result(Int(device.batteryLevel * 100))
        }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
}
