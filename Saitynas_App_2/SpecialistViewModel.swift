import Foundation
import UIKit

class SpecialistViewModel {

    private var observers: [DataSourceObserverDelegate?] = []

    private var specialist: Specialist?
    private var communicator: Communicator

    init(_ communicator: Communicator) {
        self.communicator = communicator
    }

    func loadSpecialist(id specialistId: Int) {
        communicator.getSpecialist(specialistId, onSuccess: handleReceivedSpecialist) { error in
            print("Specialist error!")
            print(error?.title)
        }
    }

    private func handleReceivedSpecialist(_ dto: SpecialistDTO?) {
        print("Specialist received!")
        guard let data = dto?.data else {
            print("Whoops")
            return
        }

        specialist = data
        observers.forEach{ $0?.onDataSourceUpdated(specialist) }
    }
}

extension SpecialistViewModel: Observable {
    func subscribe(_ observer: ObserverDelegate) {
        if let observer = observer as? DataSourceObserverDelegate {
            observers.append(observer)
        }
    }

    func unsubscribe(_ observer: ObserverDelegate) {
        observers = observers.filter { $0?.observerId != observer.observerId }
    }
}
