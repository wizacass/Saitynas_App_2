import Foundation

protocol StateObserverDelegate: AnyObject {
    var observerId: UUID { get }
    
    func onLogin()
    func onLogout()
}
