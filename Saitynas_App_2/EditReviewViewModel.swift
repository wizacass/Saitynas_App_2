import Foundation

class EditReviewViewModel: ReviewViewModel {

    var evaluation: Evaluation {
        didSet {
            observers.forEach { $0?.onDataSourceUpdated(evaluation) }
        }
    }

    private var observers: [DataSourceObserverDelegate?] = []

    init(_ communicator: Communicator, _ evaluation: Evaluation) {
        self.evaluation = evaluation

        super.init(communicator, evaluation.specialistId)
    }

    func editReview(_ comment: String, _ onSuccess: @escaping () -> Void) {
        let value = reviews[selectedIndex]
        communicator.editEvaluation(evaluation.id, value, comment, onSuccess: { [unowned self] _ in
            evaluation = Evaluation(
                id: self.evaluation.id,
                specialist: self.evaluation.specialist,
                author: self.evaluation.author,
                createdAt: self.evaluation.createdAt,
                value: value,
                comment: comment,
                specialistId: self.evaluation.specialistId
            )

            DispatchQueue.main.async(execute: onSuccess)
        }, onError: { _ in })
    }
}

extension EditReviewViewModel: Observable {
    func subscribe(_ observer: ObserverDelegate) {
        if let observer = observer as? DataSourceObserverDelegate {
            observers.append(observer)
        }
    }

    func unsubscribe(_ observer: ObserverDelegate) {
        observers = observers.filter { $0?.observerId != observer.observerId }
    }
}
