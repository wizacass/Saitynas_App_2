import Foundation

class ConsultationsViewModel {

    var selectedSpecialityIndex = 0
    var specialities: [Speciality] = []

    var activeSpeciality: Speciality {
        return specialities[selectedSpecialityIndex]
    }

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

        specialities = data
        observers.forEach { $0?.onDataSourceUpdated(specialities) }
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
