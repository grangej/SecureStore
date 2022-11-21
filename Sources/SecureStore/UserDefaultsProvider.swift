import Foundation

public class UserDefaultsStore: SecureStoreProvider {
    public func set(value: Data?, forKey key: SecureStore.SecureKey) {
        store.set(value, forKey: key.value)
    }
    
    public func value(_ key: SecureStore.SecureKey) -> Data? {
        return store.data(forKey: key.value)
    }
    

    let store = UserDefaults.standard

    public func set(value: String?, forKey key: SecureStore.SecureKey) {

        store.set(value, forKey: key.value)
    }

    public func value(_ key: SecureStore.SecureKey) -> String? {
        return store.string(forKey: key.value)
    }

    public func clearAll() {

        let dictionary = store.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            store.removeObject(forKey: key)
        }
    }

    public init() {


    }
}
