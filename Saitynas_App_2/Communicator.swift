import Foundation

class Communicator {
    
    private var apiClient: ApiClient
    private var authenticationManager: AuthenticationManager
    
    init(_ apiClient: ApiClient, _ authenticationManager: AuthenticationManager) {
        self.apiClient = apiClient
        self.authenticationManager = authenticationManager
    }
    
    func getMessage(
        onSuccess: @escaping (MessageDTO?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        apiClient.get("", onSuccess, onError: handleError)
    }
}

// MARK: - Specialists
extension Communicator {
    func getSpecialists(
        onSuccess: @escaping (SpecialistsDTO?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/specialists"
        apiClient.get(endpoint, onSuccess, onError: { [weak self] error in
            self?.retryGetRequest(endpoint, error, onSuccess, onError: handleError)
        })
    }
    
    func getSpecialist(
        _ id: Int,
        onSuccess: @escaping (SpecialistDTO?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/specialists/\(id)"
        apiClient.get(endpoint, onSuccess, onError: { [weak self] error in
            self?.retryGetRequest(endpoint, error, onSuccess, onError: handleError)
        })
    }
}

// MARK: - Requests retry
extension Communicator {
    private func retryGetRequest<T: Decodable>(
        _ endpoint: String,
        _ error: ErrorDTO?,
        _ onSuccess: @escaping (T?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        if error?.type == 401 {
            authenticationManager.refreshTokens(onSuccess: { [weak self] in
                self?.apiClient.get(endpoint, onSuccess, onError: handleError)
            }, onError: handleError)
        } else {
            DispatchQueue.main.async { handleError(error) }
        }
    }
}
