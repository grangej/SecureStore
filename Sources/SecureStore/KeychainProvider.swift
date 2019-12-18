import KeychainSwift

extension KeychainSwift: SecureStoreProvider {
    public func set(value: String?, forKey key: SecureStore.SecureKey) {

        guard let value = value else {

            self.delete(key.key)
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
