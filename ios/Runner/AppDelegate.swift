import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // تفعيل خاصية الحماية
    self.window?.makeSecure()

    // تسجيل الإضافات
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

extension UIWindow {
  func makeSecure() {
    // إنشاء حقل نصي مخفي لتمكين حماية الشاشة
    let field = UITextField()
    field.isSecureTextEntry = true
    self.addSubview(field)
    field.translatesAutoresizingMaskIntoConstraints = false
    field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    self.layer.superlayer?.addSublayer(field.layer)
    field.layer.superlayer?.sublayers?.first?.addSublayer(self.layer)
  }
}
