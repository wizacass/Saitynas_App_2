import Foundation

class Communicator {
    
    private var apiClient: ApiClient
    
    init(_ apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func getMessage(
        onSuccess: @escaping (MessageDTO?) -> Void,
        onError: @escaping (ErrorDTO?) -> Void
    ) {
        apiClient.get("", onSuccess, onError)
    }
    
    func getSpecialists(
        onSuccess: @escaping (SpecialistsDTO?) -> Void,
        onError: @escaping (ErrorDTO?) -> Void
    ) {
        apiClient.get("/specialists", onSuccess, onError)
    }
}
