import Foundation

class ConsultationsService {

    private var communicator: Communicator
    private var tokensRepository: UserTokensRepository
    private var userPreferences: UserPreferences

    init(_ communicator: Communicator, _ tokensRepository: UserTokensRepository, _ userPreferences: UserPreferences) {
        self.communicator = communicator
        self.tokensRepository = tokensRepository
        self.userPreferences = userPreferences
    }

    func requestConsultation(_ specialityId: Int? = nil, onSuccess: @escaping () -> Void) {
        guard let deviceToken = tokensRepository.deviceToken else { return }

        communicator.requestConsultation(
            deviceToken,
            specialityId,
            onSuccess: { [weak self] dto in
                self?.userPreferences.consultationId = dto?.data.id
                onSuccess()
            }, onError: { error in
                print("Error in requesting consultation: \(error?.title ?? "FATAL ERROR")")
            })
    }
    
    func cancelConsultation(onSuccess: @escaping () -> Void) {
        guard
            let consultationId = userPreferences.consultationId,
            let deviceToken = tokensRepository.deviceToken
        else { return }

        communicator.cancelConsultation(consultationId, deviceToken, onSuccess: { [weak self] _ in
            self?.userPreferences.consultationId = nil
            onSuccess()
        }, onError: { error in
            print("Error in cancelling consultation: \(error?.title ?? "FATAL ERROR")")
        })
    }

    func endConsultation(onSuccess: @escaping () -> Void) {
        guard
            let consultationId = userPreferences.consultationId,
            let deviceToken = tokensRepository.deviceToken
        else { return }

        communicator.endConsultation(consultationId, deviceToken, onSuccess: { [weak self] _ in
            self?.userPreferences.consultationId = nil
            onSuccess()
        }, onError: { error in
            print("Error in ending consultation: \(error?.title ?? "FATAL ERROR")")
        })
    }
}
