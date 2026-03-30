import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController

    self.setFrame(windowFrame, display: true)
    // self.titlebarAppearsTransparent = true
    // self.titleVisibility = .hidden
    // self.styleMask.insert(.fullSizeContentView)
    // setupTrafficLights()

    RegisterGeneratedPlugins(registry: flutterViewController)
    super.awakeFromNib()
  }

  private func setupTrafficLights() {
    guard let closeButton = standardWindowButton(.closeButton),
      let miniaturizeButton = standardWindowButton(.miniaturizeButton),
      let zoomButton = standardWindowButton(.zoomButton)
    else {
      return
    }

    guard let titlebarView = closeButton.superview else { return }

    closeButton.translatesAutoresizingMaskIntoConstraints = false
    miniaturizeButton.translatesAutoresizingMaskIntoConstraints = false
    zoomButton.translatesAutoresizingMaskIntoConstraints = false

    let verticalCenterY: CGFloat = 28.0
    let leadingPadding: CGFloat = 16.0
    let buttonSpacing: CGFloat = 6.0

    NSLayoutConstraint.activate([
      closeButton.leadingAnchor.constraint(
        equalTo: titlebarView.leadingAnchor,
        constant: leadingPadding
      ),
      closeButton.centerYAnchor.constraint(
        equalTo: titlebarView.topAnchor,
        constant: verticalCenterY
      ),

      miniaturizeButton.leadingAnchor.constraint(
        equalTo: closeButton.trailingAnchor,
        constant: buttonSpacing
      ),
      miniaturizeButton.centerYAnchor.constraint(
        equalTo: closeButton.centerYAnchor
      ),

      zoomButton.leadingAnchor.constraint(
        equalTo: miniaturizeButton.trailingAnchor,
        constant: buttonSpacing
      ),
      zoomButton.centerYAnchor.constraint(
        equalTo: closeButton.centerYAnchor
      ),
    ])
  }
}
