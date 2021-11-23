import Foundation
import KeychainSwift

class KeychainStorage: KeyValueStorageProtocol {
    
    private let keychain = KeychainSwift(keyPrefix: "\(Bundle.main.bundleIdentifier!).")
    
    func get(_ key: String) -> String? {
        return keychain.get(key)
    }
    
    func set(_ value: String, for key: String) {
        keychain.set(value, forKey: key)
    }
    
    func delete(_ key: String) {
        keychain.delete(key)
    }
}
