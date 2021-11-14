import Foundation

class AuthenticationManager  {

    //    var isLoggedIn: Bool

    private var communicator: AccessCommunicator
    private var observers: [StateObserverDelegate?] = []
    //    private var repository: UserTokensRepository

    init(_ communicator: AccessCommunicator) {
        self.communicator = communicator
        //        self.repository = repository

        //        isLoggedIn = repository.accessToken != nil
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

        //            self?.saveTokens(tokens)
        //
                    print("Jwt: \(tokens.jwt)")

                    self?.observers.forEach { $0?.onLogin() }
                    handleLogin(nil)
                } onError: { error in
                    handleLogin(error)
                }
    }

    func signup() {}

    //    private func saveTokens(_ tokens: AccessTokens) {
    //        repository.accessToken = tokens.jwt
    //        repository.refreshToken = tokens.refreshToken
    //        isLoggedIn = true
    //    }

    func logout() {
        //        repository.clearAll()
        //        isLoggedIn = false
        print("Logged out!")
        observers.forEach { $0?.onLogout() }
    }
}
