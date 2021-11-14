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

    func subscribe(_ observer: StateObserverDelegate) {
        observers.append(observer)
    }

    func unsubscribe(_ observer: StateObserverDelegate) {
        observers = observers.filter { $0?.observerId != observer.observerId }
    }

    func login(_ email: String, _ password: String, onComplete handleLogin: @escaping (ErrorDTO?) -> Void) {
        communicator.login(email, password) { [weak self] tokens in
            guard let tokens = tokens else {
                handleLogin(ErrorDTO(type: -1, title: "serialization_Error", details: "login"))
                return
            }

            self?.saveTokens(tokens)
            self?.observers.forEach { $0?.onLogin() }

            handleLogin(nil)
        } onError: { error in
            handleLogin(error)
        }
    }

    func signup() { }

    private func saveTokens(_ tokens: TokensDTO) {
        repository.accessToken = tokens.jwt
        repository.refreshToken = tokens.refreshToken
    }

    func logout() {
        repository.clearAll()
        observers.forEach { $0?.onLogout() }
    }
}
