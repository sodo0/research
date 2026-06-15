import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    RegisterGeneratedPlugins(registry: flutterViewController)

    // ── Phone-like window (iPhone 14 ratio: 390 × 844) ──────────
    let phoneWidth:  CGFloat = 390
    let phoneHeight: CGFloat = 844

    // Lock to exact phone size — non-resizable
    self.minSize = NSSize(width: phoneWidth, height: phoneHeight)
    self.maxSize = NSSize(width: phoneWidth, height: phoneHeight)
    self.setContentSize(NSSize(width: phoneWidth, height: phoneHeight))

    // Remove resize handle from title bar
    self.styleMask.remove(.resizable)

    // Center on screen after setting size
    self.center()

    super.awakeFromNib()
  }
}
