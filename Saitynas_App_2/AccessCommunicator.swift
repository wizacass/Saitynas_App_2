import Foundation

class AccessCommunicator {

    private var apiClient: ApiClient

    init(_ apiClient: ApiClient) {
        self.apiClient = apiClient
    }

    func login(
        _ email: String,
        _ password: String,
        onSuccess: @escaping (TokensDTO?) -> Void,
        onError: @escaping (ErrorDTO?) -> Void
    ) {
        let body = [
            "email": email,
            "password": password,
        ]

        apiClient.post("/login", body, onSuccess, onError)
    }

    func signup(
        _ email: String,
        _ password: String,
        onSuccess: @escaping (TokensDTO?) -> Void,
        onError: @escaping (ErrorDTO?) -> Void
    ) { }
}
