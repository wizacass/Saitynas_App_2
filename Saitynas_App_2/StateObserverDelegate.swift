import Foundation

protocol StateObserverDelegate: ObserverDelegate {
    func onLogin()
    func onLogout()
}
