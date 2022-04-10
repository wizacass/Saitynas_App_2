import Foundation

class ConsultationsService {

    private var communicator: Communicator
    private var tokensRepository: UserTokensRepository

    init(_ communicator: Communicator, _ tokensRepository: UserTokensRepository) {
        self.communicator = communicator
        self.tokensRepository = tokensRepository
    }

    func requestConsultation(_ specialityId: Int? = nil, onSuccess: @escaping () -> Void) {
        guard let deviceToken = tokensRepository.deviceToken else { return }

        communicator.requestConsultation(
            deviceToken,
            specialityId,
            onSuccess: { _ in onSuccess() },
            onError: { error in
                print("Error in requesting consultation: \(error?.title ?? "FATAL ERROR")")
            })
    }

    private func handleConsultationRequested(_ data: NullObject?) {
        print("Consultation queued!")
    }
}
