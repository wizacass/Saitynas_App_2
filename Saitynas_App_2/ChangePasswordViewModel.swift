import Foundation

class ChangePasswordViewModel: AuthenticationViewModel {
    private weak var delegate: ChangePasswordViewControllerProtocol?

    var isCurrentPasswordValid = false {
        didSet { checkEnableChangeButton() }
    }

    var currentPasswordError: String? {
        didSet {
            delegate?.setCurrentPasswordError(currentPasswordError)
            isCurrentPasswordValid = currentPasswordError == nil
        }
    }

    var isNewPasswordValid = false {
        didSet { checkEnableChangeButton() }
    }

    var newPasswordError: String? {
        didSet {
            delegate?.setNewPasswordError(newPasswordError)
            isNewPasswordValid = newPasswordError == nil
        }
    }

    init(viewController delegate: ChangePasswordViewControllerProtocol) {
        self.delegate = delegate
    }

    private func checkEnableChangeButton() {
        let isValid = isCurrentPasswordValid && isNewPasswordValid
        if isValid {
            delegate?.enableAction()
        } else {
            delegate?.disableAction()
        }
    }

    func checkCurrentPassword(_ password: String?) {
        currentPasswordError = validatePassword(password)
    }
    
    func checkNewPassword(_ password: String?) {
        newPasswordError = validateNewPassword(password)
    }
}
