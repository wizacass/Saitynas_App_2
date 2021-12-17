import Foundation

class EvaluationsTableViewModel {
    private var observers: [DataSourceObserverDelegate?] = []
    private var specialistId: Int?

    var count: Int {
        return evaluations.count
    }

    var averageRating: Double {
        let rating = evaluations.reduce(0.0) {
            return $0 + Double($1.value) / Double(count)
        }

        return Double(round(100 * rating) / 100)
    }

    private var communicator: Communicator
    private var evaluations: [Evaluation] = []

    init(_ communicator: Communicator, _ specialistId: Int? = nil) {
        self.communicator = communicator
        self.specialistId = specialistId
    }

    func loadSpecialistEvaluations() {
        if let specialistId = specialistId {
            communicator.getSpecialistEvaluations(specialistId, onSuccess: handleEvaluationsReceived) { _ in }
        } else {
            communicator.getMyEvaluations(onSuccess: handleEvaluationsReceived) { _ in }
        }
    }

    private func handleEvaluationsReceived(_ dto: EvaluationsDTO?) {
        guard let data = dto?.data else { return }

        evaluations = data.sorted(by: { $0.value > $1.value })

        observers.forEach { $0?.onDataSourceUpdated(NullObject.instance) }
    }

    func getFilteredEvaluations(_ email: String) -> [Evaluation] {
        return evaluations.filter({$0.author == email})
    }

    func getEvaluation(at index: Int) -> Evaluation {
        return evaluations[index]
    }
}

extension EvaluationsTableViewModel: Observable {
    func subscribe(_ observer: ObserverDelegate) {
        if let observer = observer as? DataSourceObserverDelegate {
            observers.append(observer)
        }
    }

    func unsubscribe(_ observer: ObserverDelegate) {
        observers = observers.filter { $0?.observerId != observer.observerId }
    }
}
