import Foundation

class WorkplaceTableViewModel {

    private var observers: [DataSourceObserverDelegate?] = []

    var count: Int {
        return workplaces.count
    }

    private var communicator: Communicator
    private var workplaces: [Workplace] = []

    init(_ communicator: Communicator) {
        self.communicator = communicator
        loadSpecialists()
    }

    private func loadSpecialists() {
        communicator.getWorkplaces(onSuccess: handleWorkplacessReceived) { _ in }
    }

    private func handleWorkplacessReceived(_ dto: WorkplacesDTO?) {
        guard let data = dto?.data else { return }

        workplaces = data

        observers.forEach { $0?.onDataSourceUpdated(NullObject.instance) }
    }

    func getWorkplace(at index: Int) -> Workplace {
        return workplaces[index]
    }
}

extension WorkplaceTableViewModel: Observable {
    func subscribe(_ observer: ObserverDelegate) {
        if let observer = observer as? DataSourceObserverDelegate {
            observers.append(observer)
        }
    }

    func unsubscribe(_ observer: ObserverDelegate) {
        observers = observers.filter { $0?.observerId != observer.observerId }
    }
}
