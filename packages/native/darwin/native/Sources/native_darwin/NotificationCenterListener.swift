import Foundation

@objc public class NotificationCenterListener: NSObject {
    @objc public init(object: NSObject, name: NSNotification.Name, callback: @escaping () -> Void) {
        self.callback = callback
        self.isListening = true

        super.init()

        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(onNotification),
                name: name,
                object: object)
    }

    deinit {
        if !isListening { return }
        NotificationCenter.default.removeObserver(self)
    }

    @objc public func stop() {
        if !isListening { return }

        isListening = false
        NotificationCenter.default.removeObserver(self)
    }

    private let callback: () -> Void
    private var isListening: Bool

    @objc public func onNotification() {
        self.callback()
    }
}
