import Foundation
#if canImport(ObjectiveC)

/// Provides simplistic inter-app communications via a _Darwin Notification Center_.
///
/// The Darwin Notify Center has no notion of per-user sessions, all notifications are system-wide.
open class DarwinBroadcaster {

    /// A stable/unique identifier used to distinguish notifications.
    public struct Identifier: Hashable, ExpressibleByStringLiteral {
        public let rawValue: String
        public init(stringLiteral value: String) {
            rawValue = value
        }
    }

    /// Callback signature.
    public typealias Handler = () -> Void

    /// Darwin Notification Center.
    private let notificationCenter: CFNotificationCenter
    /// Prefix unique to this `Broadcaster`.
    private let prefix: String
    /// Registered `Identifier`s and their respective `Handler`s.
    private var handlers: [Identifier: Handler] = [:]

    /// A unsafe raw pointer to _this_ instance needed for the `CFNotificationCenter`.
    private var unsafeSelf: UnsafeRawPointer {
        return UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())
    }

    /// Initializes a `Broadcaster` with a unique prefix.
    ///
    /// Reminder: notifications are system-wide. A unique prefix or a broadcaster/listener pairing is suggested.
    public init(prefix: String = "Broadcaster.") {
        notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        if prefix.hasSuffix(".") {
            self.prefix = prefix
        } else {
            self.prefix = prefix + "."
        }
    }

    deinit {
        CFNotificationCenterRemoveObserver(notificationCenter, unsafeSelf, nil, nil)
    }

    /// Registers a `Identifier`/`Handler` pairing.
    public final func register(_ identifier: Identifier, handler: @escaping Handler) {
        handlers[identifier] = handler
        let name = notificationName(identifier).rawValue
        CFNotificationCenterAddObserver(notificationCenter, unsafeSelf, handleDarwinNotification, name, nil, .deliverImmediately)
    }

    /// Removes the `Handler` for the provided `Identifier`.
    public final func unregister(_ identifier: Identifier) {
        handlers[identifier] = nil
        CFNotificationCenterRemoveObserver(notificationCenter, unsafeSelf, notificationName(identifier), nil)
    }

    /// Posts a notification for the provided `Identifier`.
    public final func post(_ identifier: Identifier) {
        CFNotificationCenterPostNotification(notificationCenter, notificationName(identifier), nil, nil, true)
    }

    final internal func handle(_ notificationName: CFNotificationName) {
        handle(identifier(notificationName))
    }

    private func handle(_ identifier: Identifier) {
        handlers[identifier]?()
    }

    private func notificationName(_ identifier: Identifier) -> CFNotificationName {
        return CFNotificationName(rawValue: (prefix + identifier.rawValue as CFString))
    }

    private func identifier(_ notificationName: CFNotificationName) -> Identifier {
        let stringValue = notificationName.rawValue as String
        return Identifier(stringLiteral: stringValue.replacingOccurrences(of: prefix, with: ""))
    }
}

/// Function that is executed when a specific registered notification is delivered.
private func handleDarwinNotification(center: CFNotificationCenter?, observer: UnsafeMutableRawPointer?, name: CFNotificationName?, object: UnsafeRawPointer?, userInfo: CFDictionary?) {
    guard let observer = observer, let name = name else {
        return
    }

    let appInformation = Unmanaged<DarwinBroadcaster>.fromOpaque(observer).takeUnretainedValue()
    appInformation.handle(name)
}
#endif
