import Foundation
import UIKit

class SignupViewModel: AuthenticationViewModel {

    var selectedRoleIndex = 0
    var roles: [EnumDTO] = []

    var selectedRole: Int {
        return roles[selectedRoleIndex].id
    }

    var isEmailValid = false {
        didSet { checkEnableSignupButton() }
    }

    var emailError: String? {
        didSet {
            delegate?.setEmailError(emailError)
            isEmailValid = emailError == nil
        }
    }

    var isPasswordValid = false {
        didSet { checkEnableSignupButton() }
    }

    var passwordError: String? {
        didSet {
            delegate?.setPasswordError(passwordError)
            isPasswordValid = passwordError == nil
        }
    }

    private var observers: [DataSourceObserverDelegate?] = []

    private var communicator: Communicator

    private weak var delegate: AuthenticationViewControllerProtocol?

    init(
        _ communicator: Communicator,
        viewController delegate: AuthenticationViewControllerProtocol
    ) {
        self.communicator = communicator
        self.delegate = delegate
    }

    func loadRoles() {
        communicator.getRoles(onSuccess: handleReceivedRoles) { _ in }
    }

    private func handleReceivedRoles(_ dto: EnumListDTO?) {
        guard let data = dto?.data else { return }

        roles = data
        observers.forEach { $0?.onDataSourceUpdated(roles) }
    }

    func checkEmail(_ email: String?) {
        emailError = validateEmail(email)
    }

    func checkPassword(_ password: String?) {
        passwordError = validateNewPassword(password)
    }

    private func checkEnableSignupButton() {
        let isValid = isEmailValid && isPasswordValid
        if isValid {
            delegate?.enableAction()
        } else {
            delegate?.disableAction()
        }
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
