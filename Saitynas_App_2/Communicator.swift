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
        onError: @escaping (ErrorDTO?) -> Void
    ) {
        apiClient.get("", onSuccess, onError)
    }
}

// MARK: - Specialists
extension Communicator {
    func getSpecialists(
        onSuccess: @escaping (SpecialistsDTO?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let endpoint = "/specialists"
        apiClient.get(endpoint, onSuccess) { [weak self] error in
            if error?.type == 401 {
                self?.authenticationManager.refreshTokens(onSuccess: {
                    self?.apiClient.get(endpoint, onSuccess, handleError)
                }, onError: handleError)
                return
            }
            DispatchQueue.main.async { handleError(error) }
        }
    }

    func getSpecialist(
        _ id: Int,
        onSuccess: @escaping (SpecialistDTO?) -> Void,
        onError: @escaping (ErrorDTO?) -> Void
    ) {
        apiClient.get("/specialists/\(id)", onSuccess, onError)
    }

    private func handleApiError(_ error: ErrorDTO?, onError: @escaping (ErrorDTO?) -> Void) {
        if error?.type == 401 {
            //            authenticationManager.refreshTokens(onSuccess: { }, onError: <#T##(ErrorDTO?) -> Void#>)
        }
    }
}
