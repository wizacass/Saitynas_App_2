import Foundation
import UIKit

class CreateReviewViewModel: ReviewViewModel {
    func sendReview(_ comment: String, _ onSuccess: @escaping () -> Void) {
        let value = reviews[selectedIndex]
        communicator?.postEvaluation(value, comment, specialistId, consultationId, onSuccess: { _ in
            DispatchQueue.main.async(execute: onSuccess)
        }, onError: { _ in })
    }
}
