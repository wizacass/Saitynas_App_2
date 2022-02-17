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
    
    init(
        _ communicator: Communicator,
        _ authenticationManager: AuthenticationManager,
        _ jwtUser: JwtUser,
        _ preferences: UserPreferences
    ) {
        self.communicator = communicator
        self.authenticationManager = authenticationManager
        self.jwtUser = jwtUser
        self.preferences = preferences
    }
}
