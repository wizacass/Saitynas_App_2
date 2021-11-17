import Foundation

protocol Observable {
    func subscribe(_ observer: ObserverDelegate)
    func unsubscribe(_ observer: ObserverDelegate)
}
