import Foundation
import KeychainSwift

public protocol SecureStoreProvider {
    typealias Key = SecureStore.SecureKey

    mutating func set(value: String?, forKey key: Key) async
    mutating func set(value: Data?, forKey key: Key) async
    func value(_ key: Key) async -> String?
    func value(_ key: Key) async -> Data?
    func clearAll() async
}

extension SecureStore.SecureKey {

    func finalKey(keyPrefix: String?) -> Self {

        if let keyPrefix = keyPrefix {

            return .init("\(keyPrefix)_\(self)")
        }

        return self
    }
}

extension SecureStore.SecureKey {

    static let facebookId = SecureStore.SecureKey.init("SecureKey.facebookId")
    static let appleId = SecureStore.SecureKey.init("SecureKey.appleId")
    static let appleFirstName = SecureStore.SecureKey.init("SecureKey.appleFirstName")
    static let appleLastName = SecureStore.SecureKey.init("SecureKey.appleLastName")
    static let appleEmail = SecureStore.SecureKey.init("SecureKey.appleEmail")
    static let username = SecureStore.SecureKey.init("SecureKey.username")
    static let password = SecureStore.SecureKey.init("SecureKey.password")
    static let sessionToken = SecureStore.SecureKey.init("SecureKey.sessionToken")

    static func other(key: String) -> SecureStore.SecureKey {
        return .init(key)
    }
}

public actor SecureStore: SecureStoreProvider {

    public struct SecureKey: ExpressibleByStringLiteral {
        let value: String

        public init(_ value: String) {
            self.value = value
        }

        public init(stringLiteral value: String) {
            self.value = value
        }
    }

    public static var defaultStore: SecureStore = SecureStore()
    private var provider: SecureStoreProvider
    private let keyPrefix: String?
    
    public init(accessGroup: String? = nil, keyPrefix: String? = nil) {

        let provider = KeychainSwift()
        provider.synchronizable = false
        provider.accessGroup = accessGroup
        self.init(provider: provider, keyPrefix: keyPrefix)
    }

    public func keyChainSynchronizable(_ enabled: Bool) {
        (provider as? KeychainSwift)?.synchronizable = enabled
    }

    public init(provider: SecureStoreProvider, keyPrefix: String? = nil) {
        self.provider = provider
        self.keyPrefix = keyPrefix
    }

    public func set(value: String?, forKey key: SecureStore.SecureKey) async {
        await provider.set(value: value, forKey: key.finalKey(keyPrefix: keyPrefix))
    }

    public func value(_ key: SecureStore.SecureKey) async -> String? {
        return await provider.value(key.finalKey(keyPrefix: keyPrefix))
    }
    
    public func set(value: Data?, forKey key: SecureKey) async {
        await provider.set(value: value, forKey: key.finalKey(keyPrefix: keyPrefix))
    }
    
    public func value(_ key: SecureKey) async -> Data? {
        return await provider.value(key.finalKey(keyPrefix: keyPrefix))
    }

    public func clearAll() async {
        await provider.clearAll()
    }
}


