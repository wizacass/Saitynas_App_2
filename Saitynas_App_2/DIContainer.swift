import Foundation

class DIContainer {
    
    private static let instance: DIContainer = Bootstrapper().createContainer()
    
    static var shared: DIContainer {
        return instance
    }
    
    let communicator: Communicator
    let authenticationManager: AuthenticationManager
    let jwtUser: JwtUser
    let preferences: UserPreferences
    let tokensRepository: UserTokensRepository
    let notificationsService: RemoteNotificationsService
    let consultationsService: ConsultationsService

    init(
        _ communicator: Communicator,
        _ authenticationManager: AuthenticationManager,
        _ jwtUser: JwtUser,
        _ preferences: UserPreferences,
        _ tokensRepository: UserTokensRepository,
        _ notificationsService: RemoteNotificationsService,
        _ consultationsService: ConsultationsService
    ) {
        self.communicator = communicator
        self.authenticationManager = authenticationManager
        self.jwtUser = jwtUser
        self.preferences = preferences
        self.tokensRepository = tokensRepository
        self.notificationsService = notificationsService
        self.consultationsService = consultationsService
    }
}
