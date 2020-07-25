import Foundation
import KeychainSwift

public protocol SecureStoreProvider {

    func set(value: String?, forKey key: SecureStore.SecureKey)
    func value(_ key: SecureStore.SecureKey) -> String?
    func clearAll()
}

public class SecureStore: SecureStoreProvider {

    public enum SecureKey {

        case facebookId
        case appleId
        case appleFirstName
        case appleLastName
        case appleEmail
        case username
        case password
        case sessionToken
        case other(key: String)

        public var key: String {
            switch self {
            case .facebookId: return "SecureKey.facebookId"
            case .appleId: return "SecureKey.appleId"
            case .appleFirstName: return "SecureKey.appleFirstName"
            case .appleLastName: return "SecureKey.appleLastName"
            case .appleEmail: return "SecureKey.appleEmail"

            case .username: return "SecureKey.username"
            case .password: return "SecureKey.password"
            case .sessionToken: return "SecureKey.sessionToken"
            case .other(let key): return "SecureKey.\(key)"
            }
        }
    }

    public static var defaultStore: SecureStore = SecureStore()
    private let provider: SecureStoreProvider

    public convenience init() {

        let provider = KeychainSwift()
        provider.synchronizable = false
        self.init(provider: provider)
    }

    public func keyChainSynchronizable(_ enabled: Bool) {
        (provider as? KeychainSwift)?.synchronizable = enabled
    }

    public required init(provider: SecureStoreProvider) {

        self.provider = provider
    }

    public func set(value: String?, forKey key: SecureStore.SecureKey) {
        provider.set(value: value, forKey: key)
    }

    public func value(_ key: SecureStore.SecureKey) -> String? {
        return provider.value(key)
    }

    public func clearAll() {
        provider.clearAll()
    }

}
