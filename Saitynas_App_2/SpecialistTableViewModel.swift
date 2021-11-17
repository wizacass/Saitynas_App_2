import Foundation

class SpecialistTableViewModel {

    private var observers: [DataSourceObserverDelegate?] = []

    var count: Int {
        return specialists.count
    }

    private var communicator: Communicator
    private var specialists: [Specialist] = []

    init(_ communicator: Communicator) {
        self.communicator = communicator
        loadSpecialists()
    }

    private func loadSpecialists() {
        specialists.append(Specialist(id: 1, firstName: "John", lastName: "Smith", speciality: "Doctor", address: nil))
        specialists.append(Specialist(id: 2, firstName: "Good", lastName: "Doktor", speciality: "GP", address: nil))
        
        observers.forEach { $0?.onDataSourceUpdated() }
    }

    func getSpecialist(at index: Int) -> Specialist {
        return specialists[index]
    }
}

extension SpecialistTableViewModel: Observable {
    func subscribe(_ observer: ObserverDelegate) {
        if let observer = observer as? DataSourceObserverDelegate {
            observers.append(observer)
        }
    }

    func unsubscribe(_ observer: ObserverDelegate) {
        observers = observers.filter { $0?.observerId != observer.observerId }
    }
}
