import UIKit

class ChangePasswordViewController: AccessControllerBase {

    @IBOutlet weak var currentPasswordTextField: InputField!
    @IBOutlet weak var currentPasswordErrorLabel: UILabel!

    @IBOutlet weak var newPasswordTextField: InputField!
    @IBOutlet weak var newPasswordErrorLabel: UILabel!

    @IBOutlet weak var changePasswordButton: PrimaryButton!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    private var viewModel: ChangePasswordViewModel!
    private var authenticationManager: AuthenticationManager!

    override func viewDidLoad() {
        super.viewDidLoad(bottomConstraint)

        changePasswordButton.disable()

        viewModel = ChangePasswordViewModel(viewController: self)
        authenticationManager = DIContainer.shared.authenticationManager
    }

    @IBAction func currentPasswordEditingDidBegin(_ sender: InputField) {
        currentPasswordErrorLabel.isHidden = true
        sender.borderColor = inputBorderColor
    }

    @IBAction func currentPasswordEditingChanged(_ sender: InputField) {
        viewModel.checkCurrentPassword(sender.text)
    }

    @IBAction func currentPasswordEditingDidEnd(_ sender: InputField) {
        viewModel.checkCurrentPassword(sender.text)

        currentPasswordErrorLabel.isHidden = viewModel.isCurrentPasswordValid
        sender.borderColor = viewModel.isCurrentPasswordValid ? inputBorderColor : errorColor
    }

    @IBAction func newPasswordEditingDidBegin(_ sender: InputField) {
        newPasswordErrorLabel.isHidden = true
        sender.borderColor = inputBorderColor
    }

    @IBAction func newPasswordEditingChanged(_ sender: InputField) {
        viewModel.checkNewPassword(sender.text)
    }

    @IBAction func newPasswordEditingDidEnd(_ sender: InputField) {
        viewModel.checkNewPassword(sender.text)

        newPasswordErrorLabel.isHidden = viewModel.isNewPasswordValid
        sender.borderColor = viewModel.isNewPasswordValid ? inputBorderColor : errorColor
    }

    @IBAction func changePasswordButtonPressed(_ sender: PrimaryButton) {
        sender.disable()
        authenticationManager.changePassword(
            currentPasswordTextField.text,
            newPasswordTextField.text,
            onSuccess: handlePasswordChanged,
            onError: handleChangePasswordError
        )
    }

    private func handlePasswordChanged(_ obj: NullObject?) {
        authenticationManager.logout()
        dismiss(animated: true, completion: nil)
    }

    private func handleChangePasswordError(_ error: ErrorDTO?) {
        guard let error = error else { return }

        let alert = UIAlertController.createAlert(
            error.title.formattedMessage,
            error.details?.formattedMessage
        )

        present(alert, animated: true) { [weak self] in
            self?.changePasswordButton.enable()
        }
    }
}

extension ChangePasswordViewController: ChangePasswordViewControllerProtocol {
    func enableAction() {
        changePasswordButton.enable()
    }

    func disableAction() {
        changePasswordButton.disable()
    }

    func setCurrentPasswordError(_ error: String?) {
        currentPasswordErrorLabel.text = error
    }

    func setNewPasswordError(_ error: String?) {
        newPasswordErrorLabel.text = error
    }
}
