import Foundation

class DIContainer {
    
    private static let instance: DIContainer = Bootstrapper().createContainer()
    
    static var shared: DIContainer {
        return instance
    }
    
    let communicator: Communicator
    
    init(_ communicator: Communicator) {
        self.communicator = communicator
    }
}
