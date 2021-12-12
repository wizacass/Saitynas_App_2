import Foundation

class AuthenticationManager {

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

    func login(
        _ email: String,
        _ password: String,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        communicator.login(email, password, onSuccess: { [weak self] tokens in
            self?.handleAccess(tokens, onError: handleError)
        }, onError: handleError)
    }

    func signup(
        _ email: String,
        _ password: String,
        _ roleId: Int,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        communicator.signup(email, password, roleId, onSuccess: { [weak self] tokens in
            self?.handleAccess(tokens, onError: handleError)
        }, onError: handleError)
    }

    private func handleAccess(_ tokens: TokensDTO?, onError handleError: @escaping (ErrorDTO?) -> Void) {
        if trySaveTokens(tokens, onError: handleError) {
            observers.forEach { $0?.onLogin() }
        }
    }

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

    func changePassword(
        _ currentPassword: String?,
        _ newPassword: String?,
        onSuccess: @escaping (NullObject?) -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        guard
            let currentPassword = currentPassword,
            let newPassword = newPassword
        else { return }

        communicator.changePassword(currentPassword, newPassword, onSuccess: onSuccess, onError: handleError)
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
