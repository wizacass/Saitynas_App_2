import Foundation

class Bootstrapper {
    
    private let apiUrl: String
    
    init() {
        apiUrl = Bundle.main.object(forInfoDictionaryKey: "Api Url") as! String
    }
    
    func createContainer() -> DIContainer {
        return DIContainer(apiUrl)
    }
}
