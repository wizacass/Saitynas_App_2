import Foundation
import KeychainSwift

class KeychainStorage: KeyValueStorageProtocol {

    private let keychain = KeychainSwift(keyPrefix: "\(Bundle.main.bundleIdentifier!).")
    
    func getString(_ key: String) -> String? {
        return keychain.get(key)
    }

    func getBool(_ key: String) -> Bool {
        return keychain.getBool(key) ?? false
    }

    func getInt(_ key: String) -> Int? {
        if let value = keychain.get(key) {
            return Int(value)
        }

        return nil
    }
    
    func set(_ value: String, for key: String) {
        keychain.set(value, forKey: key)
    }

    func set(_ value: Bool, for key: String) {
        keychain.set(value, forKey: key)
    }

    func set(_ value: Int, for key: String) {
        keychain.set(String(value), forKey: key)
    }
    
    func delete(_ key: String) {
        keychain.delete(key)
    }
}
