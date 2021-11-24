import Foundation

class DIContainer {
    
    private static let instance: DIContainer = Bootstrapper().createContainer()
    
    static var shared: DIContainer {
        return instance
    }
    
    let communicator: Communicator
    let authenticationManager: AuthenticationManager
    let jwtUser: JwtUser
    
    init(
        _ communicator: Communicator,
        _ authenticationManager: AuthenticationManager,
        _ jwtUser: JwtUser
    ) {
        self.communicator = communicator
        self.authenticationManager = authenticationManager
        self.jwtUser = jwtUser
    }
}
