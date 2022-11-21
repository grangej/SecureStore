import KeychainSwift
import Foundation

extension KeychainSwift: SecureStoreProvider {
    
    public func set(value: Data?, forKey key: SecureStore.SecureKey) {
        guard let value = value else {
            self.delete(key.value)
            return
        }
        self.set(value, forKey: key.value, withAccess: nil)
    }
    
    public func value(_ key: SecureStore.SecureKey) -> Data? {
        return self.getData(key.value)
    }
    
    public func set(value: String?, forKey key: SecureStore.SecureKey) {

        guard let value = value else {

            self.delete(key.value)
            return 
        }

        self.set(value, forKey: key.value)
    }

    public func value(_ key: SecureStore.SecureKey) -> String? {

        return self.get(key.value)
    }

    public func clearAll() {

        self.clear()
    }
}
