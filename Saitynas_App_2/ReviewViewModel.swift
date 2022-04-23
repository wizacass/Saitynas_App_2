import Foundation

class ReviewViewModel {

    var selectedIndex: Int = 0

    var specialistId: Int?
    var consultationId: String?

    var communicator: Communicator?

    let reviews = (1...10).reversed().map { $0 }

    init(_ communicator: Communicator?, _ specialistId: Int?) {
        self.specialistId = specialistId
        self.communicator = communicator
    }

    init(_ communicator: Communicator?, _ consultationId: String?) {
        self.consultationId = consultationId
        self.communicator = communicator
    }
}
