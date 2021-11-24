import Foundation
import UIKit

class SignupViewModel {

    var selectedRoleIndex = 0
    var roles: [EnumDTO] = []

    private var observers: [DataSourceObserverDelegate?] = []

    private var communicator: Communicator
    private var authenticationManager: AuthenticationManager

    init(_ communicator: Communicator, _ authenticationManager: AuthenticationManager) {
        self.communicator = communicator
        self.authenticationManager = authenticationManager
    }

    func loadRoles() {
        communicator.getRoles(onSuccess: handleReceivedRoles) { _ in }
    }

    private func handleReceivedRoles(_ dto: EnumListDTO?) {
        guard let data = dto?.data else { return }

        roles = data
        observers.forEach { $0?.onDataSourceUpdated(roles) }
    }

    func signup(_ email: String, _ password: String, onSuccess: @escaping () -> Void) {
        let roleId = roles[selectedRoleIndex].id
        authenticationManager.signup(email, password, roleId, onSuccess: onSuccess, onError: { error in
            print("Signup error!")
            print(error?.title)
        })
    }
}

extension SignupViewModel: Observable {
    func subscribe(_ observer: ObserverDelegate) {
        if let observer = observer as? DataSourceObserverDelegate {
            observers.append(observer)
        }
    }

    func unsubscribe(_ observer: ObserverDelegate) {
        observers = observers.filter { $0?.observerId != observer.observerId }
    }
}
