import KeychainSwift
import Foundation

extension KeychainSwift: SecureStoreProvider {
    
    public func set(value: Data?, forKey key: SecureStore.SecureKey) {
        guard let value = value else {
            self.delete(key.key)
            return
        }
        self.set(value, forKey: key.key, withAccess: nil)
    }
    
    public func value(_ key: SecureStore.SecureKey) -> Data? {
        return self.getData(key.key)
    }
    
    public func set(value: String?, forKey key: SecureStore.SecureKey) {

        guard let value = value else {

            self.delete(key.key)
            return 
        }

        self.set(value, forKey: key.key)
    }

    public func value(_ key: SecureStore.SecureKey) -> String? {

        return self.get(key.key)
    }

    public func clearAll() {

        self.clear()
    }
}
