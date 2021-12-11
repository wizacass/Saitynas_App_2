import Foundation

class LoginViewModel: AuthenticationViewModel {
    private weak var delegate: AuthenticationViewControllerProtocol?

    var isEmailValid = false {
        didSet { checkEnableLoginButton() }
    }

    var emailError: String? {
        didSet {
            delegate?.setEmailError(emailError)
            isEmailValid = emailError == nil
        }
    }

    var isPasswordValid = false {
        didSet { checkEnableLoginButton() }
    }

    var passwordError: String? {
        didSet {
            delegate?.setPasswordError(passwordError)
            isPasswordValid = passwordError == nil
        }
    }

    init(viewController delegate: AuthenticationViewControllerProtocol) {
        self.delegate = delegate
    }

    func checkEmail(_ email: String?) {
        emailError = validateEmail(email)
    }

    func checkPassword(_ password: String?) {
        passwordError = validatePassword(password)
    }

    private func checkEnableLoginButton() {
        let isValid = isEmailValid && isPasswordValid
        if isValid {
            delegate?.enableAction()
        } else {
            delegate?.disableAction()
        }
    }
}
