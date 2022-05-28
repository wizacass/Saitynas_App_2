import Foundation

class ConsultationsViewModel {

    var selectedSpecialityIndex = 0
    var speciality: [Speciality] = []

    private var observers: [DataSourceObserverDelegate?] = []

    private var communicator: Communicator

    init(_ communicator: Communicator) {
        self.communicator = communicator
    }

    func loadRoles() {
        communicator.getSpecialities(onSuccess: handleReceivedRoles) { _ in }
    }

    private func handleReceivedRoles(_ dto: SpecialitiesDTO?) {
        guard let data = dto?.data else { return }

        speciality = data
        observers.forEach { $0?.onDataSourceUpdated(speciality) }
    }
}

extension ConsultationsViewModel: Observable {
    func subscribe(_ observer: ObserverDelegate) {
        if let observer = observer as? DataSourceObserverDelegate {
            observers.append(observer)
        }
    }

    func unsubscribe(_ observer: ObserverDelegate) {
        observers = observers.filter { $0?.observerId != observer.observerId }
    }
}
