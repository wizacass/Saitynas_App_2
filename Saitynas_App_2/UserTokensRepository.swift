import Foundation

class UserTokensRepository {

    private let accessTokenKey = "access_token"
    private let refreshTokenKey = "refresh_token"

    private var storage: KeyValueStorageProtocol

    init(_ storage: KeyValueStorageProtocol) {
        self.storage = storage
    }

    var accessToken: String? {
        get {
            return storage.get(accessTokenKey)
        }

        set(token) {
            guard let token = token else { return }
            storage.set(token, for: accessTokenKey)
        }
    }

    var refreshToken: String? {
        get {
            return storage.get(refreshTokenKey)
        }

        set(token) {
            guard let token = token else { return }
            storage.set(token, for: refreshTokenKey)
        }
    }

    func clearAll() {
        storage.delete(accessTokenKey)
        storage.delete(refreshTokenKey)
    }
}
