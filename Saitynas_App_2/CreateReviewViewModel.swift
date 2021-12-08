import Foundation
import UIKit

class CreateReviewViewModel {
    
    var selectedIndex: Int = 0
    
    let reviews = (1...10).reversed().map { $0 }
    
    private var communicator: Communicator
    private var specialistId: Int
    
    init(_ communicator: Communicator, _ specialistId: Int) {
        self.specialistId = specialistId
        self.communicator = communicator
    }
    
    func sendReview(_ comment: String, _ onSuccess: @escaping () -> Void) {
        let value = reviews[selectedIndex]
        communicator.postEvaluation(value, comment, specialistId, onSuccess: { _ in
            DispatchQueue.main.async(execute: onSuccess)
        }, onError: { _ in})
    }
}
