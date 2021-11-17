import Foundation

protocol DataSourceObserverDelegate: ObserverDelegate {
    func onDataSourceUpdated<T>(_ source: T?)
}
