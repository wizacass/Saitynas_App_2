import Foundation

protocol KeyValueStorageProtocol {
    
    func get(_ key: String) -> String?
    func set(_ value: String, for key: String)
    func delete(_ key: String)
}
