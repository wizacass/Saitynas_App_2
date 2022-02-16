import Foundation

protocol StateObserverDelegate: ObserverDelegate {
    func onLogin(_ user: User?)
    func onLogout()
}
