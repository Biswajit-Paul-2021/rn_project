import Foundation
import React
import Flutter

@objc(FlutterNativeModule)
class FlutterNativeModule: NSObject {
  
  private var flutterEngine: FlutterEngine?
  private var methodChannel: FlutterMethodChannel?
  private weak var flutterViewController: FlutterViewController?
  private var accessToken: String?
  private var userID: String?
  
  override init() {
    super.init()
    
    initializeFlutterEngine()
  }
  
  static func moduleName() -> String! {
    return "FlutterNativeModule"
  }
  
  /// ✅ Initialize Flutter Engine
  private func initializeFlutterEngine() {
    if flutterEngine == nil {
      flutterEngine = FlutterEngine(name: "my_engine_id")
      flutterEngine?.run()
      
      if let flutterEngine = flutterEngine {
        methodChannel = FlutterMethodChannel(
          name: "com.flutter.module.channel",
          binaryMessenger: flutterEngine.binaryMessenger
        )
        
        methodChannel?.setMethodCallHandler { [weak self] (call, result) in
          guard let self = self else { return }
          if call.method == "closeFlutterView" {
            self.closeFlutterView()  // ✅ Handle closing Flutter
          }
        }
      }
    }
  }
  
  //  if call.method == "openSDK" {
  //    self.openCommSDK()
  //  } else
  
  @objc func openCommSDK() {
    DispatchQueue.main.async {
      guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
        return
      }
      
      // ✅ Restart Flutter Engine If Needed
      if self.flutterEngine == nil {
        self.initializeFlutterEngine()
      }
      
      guard let flutterEngine = self.flutterEngine else { return }
      
      // ✅ DETACH ENGINE before reusing
      flutterEngine.viewController = nil
      
      let flutterViewController = FlutterViewController(
        engine: flutterEngine,
        nibName: nil,
        bundle: nil
      )
      flutterViewController.modalPresentationStyle = .fullScreen
      rootViewController
        .present(flutterViewController, animated: true, completion: nil)
      
      self.flutterViewController = flutterViewController  // 🔥 Keep a reference
      let arguments : [String:String?]=[
        "token": self.accessToken,
        "userId":self.userID
      ]
      
      self.methodChannel?.invokeMethod("sendData", arguments: arguments)
      
    }
  }
  
  @objc func closeFlutterView() {
    DispatchQueue.main.async {
      self.flutterViewController?.dismiss(animated: true, completion: {
        self.flutterViewController = nil  // ✅ Remove reference
        self.flutterEngine?.viewController = nil  // ✅ Detach Flutter Engine
      })
    }
  }
  
  @objc func showToast(_ token: String, userID: String) {
    DispatchQueue.main.async {
      let arguments : [String:String]=[
        "token":token,
        "userId":userID
      ]
      self.accessToken = token
      self.userID = userID
      self.methodChannel?.invokeMethod("showToast", arguments: arguments){
        (result) in
        if let response = result as? [String:Any] {
          print("Flutter responded with: \(response)")
          if(response["hasMandatoryStatus"] as? Bool == true){
            self.openCommSDK()
          }
        } else {
          print("No response from Flutter")
        }
      }
    }
  }
  
  @objc static func requiresMainQueueSetup() -> Bool {
    return true
  }
}

