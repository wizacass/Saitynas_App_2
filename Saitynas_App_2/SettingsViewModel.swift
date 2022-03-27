import Foundation

class SettingsViewModel {
    
    let onlineStatusId = 2

    private var observers: [DataSourceObserverDelegate?] = []
    private var statuses: [EnumDTO] = []

    private var communicator: Communicator

    init(_ communicator: Communicator) {
        self.communicator = communicator
    }

    func retrieveActivityStatuses(onError handleError: @escaping (ErrorDTO?) -> Void) {
        communicator.getActivityStatuses(onSuccess: handleRetrievedStatuses, onError: handleError)
    }

    private func handleRetrievedStatuses(_ dto: EnumListDTO?) {
        guard let statuses = dto?.data else { return }

        self.statuses = statuses
    }

    func retrieveUserActivityStatus(onError handleError: @escaping (ErrorDTO?) -> Void) {
        communicator.getMyActivityStatus(onSuccess: handleRetrievedUserActivityStatus, onError: handleError)
    }

    private func handleRetrievedUserActivityStatus(_ dto: GetEnumDTO?) {
        guard let status = dto?.data else { return }

        notifyObservers(status)
    }

    func updateUserActivityStatus(willGoOnline: Bool, onError handleError: @escaping (ErrorDTO?) -> Void) {
        let index = willGoOnline ? 1 : 2
        communicator.updateMyActivityStatus(statuses[index].id, onSuccess: { [weak self] _ in
            self?.notifyObservers(self?.statuses[index])
        }, onError: handleError)
    }
}

extension SettingsViewModel: Observable {
    func subscribe(_ observer: ObserverDelegate) {
        if let observer = observer as? DataSourceObserverDelegate {
            observers.append(observer)
        }
    }

    func unsubscribe(_ observer: ObserverDelegate) {
        observers = observers.filter { $0?.observerId != observer.observerId }
    }

    private func notifyObservers(_ status: EnumDTO?) {
        observers.forEach({ $0?.onDataSourceUpdated(status) })
    }
}
