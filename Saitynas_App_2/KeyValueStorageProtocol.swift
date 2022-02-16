import Foundation

protocol KeyValueStorageProtocol {
    func getString(_ key: String) -> String?
    func getBool(_ key: String) -> Bool

    func set(_ value: String, for key: String)
    func set(_ value: Bool, for key: String)

    func delete(_ key: String)
}
