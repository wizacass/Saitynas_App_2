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
    let notificationsService: RemoteNotificationsService

    init(
        _ communicator: Communicator,
        _ authenticationManager: AuthenticationManager,
        _ jwtUser: JwtUser,
        _ preferences: UserPreferences,
        _ notificationsService: RemoteNotificationsService
    ) {
        self.communicator = communicator
        self.authenticationManager = authenticationManager
        self.jwtUser = jwtUser
        self.preferences = preferences
        self.notificationsService = notificationsService
    }
}
