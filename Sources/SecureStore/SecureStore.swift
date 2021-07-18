import Foundation
import KeychainSwift

public protocol SecureStoreProvider {

    func set(value: String?, forKey key: SecureStore.SecureKey)
    func set(value: Data?, forKey key: SecureStore.SecureKey)
    func value(_ key: SecureStore.SecureKey) -> String?
    func value(_ key: SecureStore.SecureKey) -> Data?
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
        case prefixKey(key: String)

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
            case .prefixKey(let key): return "SecureKey.\(key)"
            }
        }
        
        func finalKey(keyPrefix: String?) -> SecureKey {
         
            if let keyPrefix = keyPrefix {
                
                return SecureKey.prefixKey(key: "\(keyPrefix)_\(key)")
            }
            
            return self
        }
    }

    public static var defaultStore: SecureStore = SecureStore()
    private let provider: SecureStoreProvider
    private let keyPrefix: String?
    
    public convenience init(accessGroup: String? = nil, keyPrefix: String? = nil) {

        let provider = KeychainSwift()
        provider.synchronizable = false
        provider.accessGroup = accessGroup
        self.init(provider: provider, keyPrefix: keyPrefix)
    }

    public func keyChainSynchronizable(_ enabled: Bool) {
        (provider as? KeychainSwift)?.synchronizable = enabled
    }

    public required init(provider: SecureStoreProvider, keyPrefix: String? = nil) {
        self.provider = provider
        self.keyPrefix = keyPrefix
    }

    public func set(value: String?, forKey key: SecureStore.SecureKey) {
        provider.set(value: value, forKey: key.finalKey(keyPrefix: keyPrefix))
    }

    public func value(_ key: SecureStore.SecureKey) -> String? {
        return provider.value(key.finalKey(keyPrefix: keyPrefix))
    }
    
    public func set(value: Data?, forKey key: SecureKey) {
        provider.set(value: value, forKey: key.finalKey(keyPrefix: keyPrefix))
    }
    
    public func value(_ key: SecureKey) -> Data? {
        return provider.value(key.finalKey(keyPrefix: keyPrefix))
    }

    public func clearAll() {
        provider.clearAll()
    }
}


