import Foundation

class ConsultationsService {

    private var communicator: Communicator
    private var tokensRepository: UserTokensRepository
    private var userPreferences: UserPreferences

    private var observers: [DataSourceObserverDelegate?] = []

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
                print("Error in requesting consultation: \(error?.title ?? "Unkown error")")
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
            print("Error in cancelling consultation: \(error?.title ?? "Unkown error")")
        })
    }

    func startConsultation(onSuccess: @escaping () -> Void) {
        guard
            let consultationId = userPreferences.consultationId,
            let deviceToken = tokensRepository.deviceToken
        else { return }

        communicator.startConsultation(consultationId, deviceToken, onSuccess: { [weak self] _ in
            onSuccess()
            self?.observers.forEach({ $0?.onDataSourceUpdated(NullObject.instance) })
        }, onError: { error in
            print("Error in starting consultation: \(error?.title ?? "Unkown error")")
        })
    }

    func endConsultation(onSuccess: @escaping () -> Void) {
        guard
            let consultationId = userPreferences.consultationId,
            let deviceToken = tokensRepository.deviceToken
        else { return }

        communicator.endConsultation(consultationId, deviceToken, onSuccess: {  _ in
            onSuccess()
        }, onError: { error in
            print("Error in ending consultation: \(error?.title ?? "Unkown error")")
            onSuccess()
        })
    }

    func acceptConsultation(onSuccess: @escaping () -> Void) {
        guard let deviceToken = tokensRepository.deviceToken else { return }

        communicator.acceptConsultation(deviceToken, onSuccess: { [weak self] dto in
            self?.userPreferences.consultationId = dto?.data.id
            onSuccess()
        }, onError: { error in
            print("Error in accepting consultation: \(error?.title ?? "Unkown error")")
        })
    }
}

extension ConsultationsService: Observable {
    func subscribe(_ observer: ObserverDelegate) {
        if let observer = observer as? DataSourceObserverDelegate {
            observers.append(observer)
        }
    }

    func unsubscribe(_ observer: ObserverDelegate) {
        observers = observers.filter { $0?.observerId != observer.observerId }
    }
}
