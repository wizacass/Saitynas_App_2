import Foundation

class EditReviewViewModel: ReviewViewModel {

    let evaluation: Evaluation

    init(_ communicator: Communicator, _ evaluation: Evaluation) {
        self.evaluation = evaluation

        super.init(communicator, evaluation.specialistId)
    }

    func editReview(_ comment: String, _ onSuccess: @escaping () -> Void) {
        let value = reviews[selectedIndex]
        communicator.editEvaluation(evaluation.id, value, comment, onSuccess: { _ in
            DispatchQueue.main.async(execute: onSuccess)
        }, onError: { _ in })
    }
}
