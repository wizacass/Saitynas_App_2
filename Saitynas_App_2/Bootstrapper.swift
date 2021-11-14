import Foundation

class Bootstrapper {
    
    private let apiUrl: String
    
    init() {
        apiUrl = Bundle.main.object(forInfoDictionaryKey: "Api Url") as! String
    }
    
    func createContainer() -> DIContainer {
        let apiClient = ApiClient(apiUrl)
        let communicator = Communicator(apiClient)
        let accessCommunicator = AccessCommunicator(apiClient)
        let authenticationManager = AuthenticationManager(accessCommunicator)
        
        return DIContainer(communicator, authenticationManager)
    }
}
