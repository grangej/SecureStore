import Foundation

private struct InMemoryKeychainProvider: SecureStoreProvider {

    private var storage: [String: Any] = [:]

    func value(_ key: SecureStore.SecureKey) -> String? {
        return storage[key.value] as? String
    }

    func value(_ key: SecureStore.SecureKey) -> Data? {
        return storage[key.value] as? Data
    }

    func clearAll() {

    }

    mutating func set(value: String?, forKey key: SecureStore.SecureKey) {
        storage[key.value] = value
    }

    mutating func set(value: Data?, forKey key: SecureStore.SecureKey) {
        storage[key.value] = value
    }
}

extension SecureStore {
    public static var inMemory: SecureStore {
        let provider = InMemoryKeychainProvider()
        return .init(provider: provider)
    }
}
