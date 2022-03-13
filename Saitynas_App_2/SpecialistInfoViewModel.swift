import Foundation

class SpecialistInfoViewModel {

    var selectedRoleIndex = 0
    var roles: [EnumDTO] = []

    private var observers: [DataSourceObserverDelegate?] = []

    private var communicator: Communicator

    init(
        _ communicator: Communicator
    ) {
        self.communicator = communicator
    }

    func loadRoles() {
        communicator.getSpecialities(onSuccess: handleReceivedRoles) { _ in }
    }

    private func handleReceivedRoles(_ dto: EnumListDTO?) {
        guard let data = dto?.data else { return }

        roles = data
        observers.forEach { $0?.onDataSourceUpdated(roles) }
    }
}

extension SpecialistInfoViewModel: Observable {
    func subscribe(_ observer: ObserverDelegate) {
        if let observer = observer as? DataSourceObserverDelegate {
            observers.append(observer)
        }
    }

    func unsubscribe(_ observer: ObserverDelegate) {
        observers = observers.filter { $0?.observerId != observer.observerId }
    }
}
