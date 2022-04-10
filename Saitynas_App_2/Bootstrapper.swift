import Foundation

class Bootstrapper {
    
    private let apiUrl: String

    // swiftlint:disable force_cast
    init() {
        apiUrl = Bundle.main.object(forInfoDictionaryKey: "Api Url") as! String
    }
    // swiftlint:enable force_cast
    
    func createContainer() -> DIContainer {
        let keychainStorage = KeychainStorage()
        let defaultsStorage = UserDefaultsStorage()

        let tokensRepository = UserTokensRepository(keychainStorage)
        let userPreferences = UserPreferences(defaultsStorage)
        
        let apiClient = ApiClient(apiUrl, tokensRepository)
        let accessCommunicator = AccessCommunicator(apiClient)

        let authenticationManager = AuthenticationManager(accessCommunicator, tokensRepository, userPreferences)
        let communicator = Communicator(apiClient, authenticationManager)
        
        let jwtUser = JwtUser(tokensRepository)
        authenticationManager.subscribe(jwtUser)

        let notificationsService = RemoteNotificationsService(tokensRepository)

        let consultationsService = ConsultationsService(communicator, tokensRepository, userPreferences)

        return DIContainer(
            communicator,
            authenticationManager,
            jwtUser,
            userPreferences,
            notificationsService,
            consultationsService
        )
    }
}
