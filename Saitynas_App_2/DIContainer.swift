import Foundation

class DIContainer {
    
    private static let instance: DIContainer = Bootstrapper().createContainer()
    
    static var shared: DIContainer {
        return instance
    }
    
    let communicator: Communicator
    let authenticationManager: AuthenticationManager
    
    init(
        _ communicator: Communicator,
        _ authenticationManager: AuthenticationManager
    ) {
        self.communicator = communicator
        self.authenticationManager = authenticationManager
    }
}
