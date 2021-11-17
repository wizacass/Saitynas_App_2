import Foundation

class AuthenticationManager  {

    var isLoggedIn: Bool {
        return repository.accessToken != nil
    }

    private var communicator: AccessCommunicator
    private var observers: [StateObserverDelegate?] = []
    private var repository: UserTokensRepository

    init(_ communicator: AccessCommunicator, _ repository: UserTokensRepository) {
        self.communicator = communicator
        self.repository = repository
    }

    func login(_ email: String, _ password: String, onComplete handleLoginAttempt: @escaping (ErrorDTO?) -> Void) {
        communicator.login(email, password, onSuccess: { [unowned self] tokens in
            if self.trySaveTokens(tokens, onError: handleLoginAttempt) {
                self.observers.forEach { $0?.onLogin() }
                handleLoginAttempt(nil)
            }
        }, onError: handleLoginAttempt)
    }

    func signup() { }

    func refreshTokens(onSuccess: @escaping () -> Void, onError handleError: @escaping (ErrorDTO?) -> Void) {
        guard let refreshToken = repository.refreshToken else {
            handleError(ErrorDTO("token_missing"))
            return
        }

        communicator.refreshTokens(refreshToken, onSuccess: { [weak self] tokens in
            guard let tokens = tokens else {
                handleError(ErrorDTO.serializationError("referesh_token"))
                return
            }

            self?.saveTokens(tokens)
            onSuccess()
        }, onError: handleError)

        onSuccess()
    }

    private func trySaveTokens(_ tokens: TokensDTO?, onError: @escaping (ErrorDTO?) -> Void) -> Bool {
        guard let tokens = tokens else {
            onError(ErrorDTO.serializationError("tokensDTO"))
            return false
        }

        saveTokens(tokens)
        return true
    }

    private func saveTokens(_ tokens: TokensDTO) {
        repository.accessToken = tokens.jwt
        repository.refreshToken = tokens.refreshToken
    }

    func logout() {
        repository.clearAll()
        observers.forEach { $0?.onLogout() }
    }
}

extension AuthenticationManager: Observable {
    func subscribe(_ observer: ObserverDelegate) {
        if let observer = observer as? StateObserverDelegate {
            observers.append(observer)
        }
    }

    func unsubscribe(_ observer: ObserverDelegate) {
        observers = observers.filter { $0?.observerId != observer.observerId }
    }
}
