import Foundation

class UserPreferences {

    private let hasProfileKey = "has_profile"
    private let consultationIdKey = "consultation_id"

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

    var consultationId: Int? {
        get {
            return storage.getInt(consultationIdKey)
        }

        set(value) {
            if let value = value {
                storage.set(value, for: consultationIdKey)
            } else {
                storage.delete(consultationIdKey)
            }
        }
    }

    func clearAll() {
        storage.delete(hasProfileKey)
        storage.delete(consultationIdKey)
    }
}
