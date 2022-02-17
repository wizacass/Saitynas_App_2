import Foundation

class UserPreferences {

    private let hasProfileKey = "has_profile"

    private var storage: KeyValueStorageProtocol

    init(_ storage: KeyValueStorageProtocol) {
        self.storage = storage
    }

    var hasProfile: Bool {
        get {
            return storage.getBool(hasProfileKey)
        }

        set(value) {
            storage.set(value, for: hasProfileKey)
        }
    }

    func clearAll() {
        storage.delete(hasProfileKey)
    }
}
