import Foundation

class ConsultationsTableViewModel {

    var count: Int {
        return consultations.count
    }

    private var observers: [DataSourceObserverDelegate?] = []
    private var consultations: [Consultation] = []

    private var communicator: Communicator

    init(_ communicator: Communicator) {
        self.communicator = communicator
    }

    func loadConsultations() {
        communicator.getMyConsultations(onSuccess: handleConsultationsReceived, onError: { error in
            print("Error in recveiving consultations history: \(error?.title ?? "FATAL ERROR")")
        })
    }

    private func handleConsultationsReceived(_ dto: ConsultationsDTO?) {
        guard let data = dto?.data else { return }

        consultations = data

        observers.forEach { $0?.onDataSourceUpdated(NullObject.instance) }
    }

    func getConsultation(at index: Int) -> Consultation {
        return consultations[index]
    }
}

extension ConsultationsTableViewModel: Observable {
    func subscribe(_ observer: ObserverDelegate) {
        if let observer = observer as? DataSourceObserverDelegate {
            observers.append(observer)
        }
    }

    func unsubscribe(_ observer: ObserverDelegate) {
        observers = observers.filter { $0?.observerId != observer.observerId }
    }
}
