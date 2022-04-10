import Foundation

class UserDefaultsStorage: KeyValueStorageProtocol {
    private let settings = UserDefaults.standard

    func getString(_ key: String) -> String? {
        return settings.string(forKey: key)
    }

    func getBool(_ key: String) -> Bool {
        if settings.object(forKey: key) == nil { return false }

        return settings.bool(forKey: key)
    }

    func getInt(_ key: String) -> Int? {
        return settings.integer(forKey: key)
    }

    func set(_ value: String, for key: String) {
        settings.set(value, forKey: key)
    }

    func set(_ value: Bool, for key: String) {
        settings.set(value, forKey: key)
    }

    func set(_ value: Int, for key: String) {
        settings.set(value, forKey: key)
    }

    func delete(_ key: String) {
        settings.removeObject(forKey: key)
    }
}
