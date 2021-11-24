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
            "password": password
        ]
        
        apiClient.post("/login", body, onSuccess, onError)
    }
    
    func signup(
        _ email: String,
        _ password: String,
        _ roleId: Int,
        onSuccess: @escaping (TokensDTO?) -> Void,
        onError: @escaping (ErrorDTO?) -> Void
    ) {
        let body: [String: Any] = [
            "email": email,
            "password": password,
            "role": roleId
        ]

        apiClient.post("/signup", body, onSuccess, onError)
    }
    
    func refreshTokens(
        _ refreshToken: String,
        onSuccess: @escaping (TokensDTO?) -> Void,
        onError: @escaping (ErrorDTO?) -> Void
    ) {
        let body = [
            "refreshToken": refreshToken
        ]
        
        apiClient.post("/refresh-token", body, onSuccess, onError)
    }
}
