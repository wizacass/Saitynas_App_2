import Foundation

class AccessCommunicator {
    
    private var apiClient: ApiClientProtocol
    
    init(_ apiClient: ApiClientProtocol) {
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

    func logout(
        onSuccess: @escaping (NullObject?) -> Void,
        onError: @escaping (ErrorDTO?) -> Void
    ) {
        apiClient.post("/logout", [:], onSuccess) { error in
            DispatchQueue.main.async { onSuccess(nil) }
            onError(error)
        }
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

    func changePassword(
        _ currentPassword: String,
        _ newPassword: String,
        onSuccess: @escaping (NullObject?) -> Void,
        onError: @escaping (ErrorDTO?) -> Void
    ) {
        let body = [
            "oldPassword": currentPassword,
            "newPassword": newPassword
        ]

        apiClient.put("/users/passwords", body, onSuccess, onError)
    }

    func getUserInformation(
        onSuccess: @escaping (UserDTO?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        apiClient.get("/users/me", onSuccess, onError: handleError)
    }
}
