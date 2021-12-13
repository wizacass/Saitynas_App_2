import Foundation

class ReviewViewModel {

    var selectedIndex: Int = 0

    var communicator: Communicator
    var specialistId: Int

    let reviews = (1...10).reversed().map { $0 }

    init(_ communicator: Communicator, _ specialistId: Int) {
        self.specialistId = specialistId
        self.communicator = communicator
    }
}
