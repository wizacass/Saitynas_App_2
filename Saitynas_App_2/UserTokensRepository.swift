import Foundation

class UserTokensRepository {

    private let accessTokenKey = "access_token"
    private let refreshTokenKey = "refresh_token"
    private let deviceTokenKey = "device_token"

    private var storage: KeyValueStorageProtocol

    init(_ storage: KeyValueStorageProtocol) {
        self.storage = storage
    }

    var accessToken: String? {
        get {
            return storage.getString(accessTokenKey)
        }

        set(token) {
            guard let token = token else { return }
            storage.set(token, for: accessTokenKey)
        }
    }

    var refreshToken: String? {
        get {
            return storage.getString(refreshTokenKey)
        }

        set(token) {
            guard let token = token else { return }
            storage.set(token, for: refreshTokenKey)
        }
    }

    var deviceToken: String? {
        get {
            return storage.getString(deviceTokenKey)
        }

        set(token) {
            guard let token = token else { return }
            storage.set(token, for: deviceTokenKey)
        }
    }

    func clearAll() {
        storage.delete(accessTokenKey)
        storage.delete(refreshTokenKey)
    }
}
