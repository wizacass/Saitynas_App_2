import Foundation

class Bootstrapper {
    
    private let apiUrl: String
    
    init() {
        apiUrl = Bundle.main.object(forInfoDictionaryKey: "Api Url") as! String
    }
    
    func createContainer() -> DIContainer {
        let keychainStorage = KeychainStorage()
        let tokensRepository = UserTokensRepository(keychainStorage)
        
        let apiClient = ApiClient(apiUrl, tokensRepository)
        let accessCommunicator = AccessCommunicator(apiClient)
        
        let authenticationManager = AuthenticationManager(accessCommunicator, tokensRepository)
        let communicator = Communicator(apiClient, authenticationManager)
        
        return DIContainer(communicator, authenticationManager)
    }
}
