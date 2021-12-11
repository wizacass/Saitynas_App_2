import UIKit

class SignupViewController: AccessControllerBase {

    @IBOutlet weak var emailTextField: InputField!
    @IBOutlet weak var emailErrorLabel: UILabel!

    @IBOutlet weak var passwordTextField: InputField!
    @IBOutlet weak var passwordErrorLabel: UILabel!

    @IBOutlet weak var rolePicker: UIPickerView!

    @IBOutlet weak var signupButton: PrimaryButton!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    private var viewModel: SignupViewModel!
    private var authenticationManager: AuthenticationManager!

    private let id = UUID()

    override func viewDidLoad() {
        super.viewDidLoad(bottomConstraint)

        signupButton.disable()
        initialize()
    }

    private func initialize() {
        let c = DIContainer.shared

        viewModel = SignupViewModel(c.communicator, viewController: self)
        viewModel.subscribe(self)
        viewModel.loadRoles()

        authenticationManager = c.authenticationManager
        authenticationManager.subscribe(self)

        rolePicker.delegate = self
        rolePicker.dataSource = self
    }

    @IBAction func emailEditingDidBegin(_ sender: InputField) {
        emailErrorLabel.isHidden = true
        sender.borderColor = inputBorderColor
    }

    @IBAction func emailEditingChanged(_ sender: InputField) {
        viewModel.checkEmail(sender.text)
    }

    @IBAction func emailEditingDidEnd(_ sender: InputField) {
        viewModel.checkEmail(sender.text)

        emailTextField.borderColor = viewModel.isEmailValid ? inputBorderColor : errorColor
        emailErrorLabel.isHidden = viewModel.isEmailValid
    }

    @IBAction func passwordEditingDidBegin(_ sender: InputField) {
        passwordErrorLabel.isHidden = true
        sender.borderColor = inputBorderColor
    }

    @IBAction func passwordEditingChanged(_ sender: InputField) {
        viewModel.checkPassword(sender.text)
    }

    @IBAction func passwordEditingDidEnd(_ sender: InputField) {
        viewModel.checkPassword(sender.text)

        passwordErrorLabel.isHidden = viewModel.isPasswordValid
        passwordTextField.borderColor = viewModel.isPasswordValid ? inputBorderColor : errorColor
    }

    @IBAction func signupButtonPressed(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }

        authenticationManager.signup(email, password, viewModel.selectedRole, onSuccess: {}, onError: handleSignupError)
    }

    private func handleSignupError(_ error: ErrorDTO?) {
        guard let error = error else { return }

        let alert = UIAlertController.createAlert(
            error.title.formattedMessage,
            error.details?.formattedMessage
        )

        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Role picker Data Source
extension SignupViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.roles.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.roles[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedRoleIndex = row
    }
}

extension SignupViewController: AuthenticationViewControllerProtocol {
    func enableAction() { signupButton.enable() }

    func disableAction() { signupButton.disable() }

    func setEmailError(_ error: String?) {
        emailErrorLabel.text = error
    }

    func setPasswordError(_ error: String?) {
        passwordErrorLabel.text = error
    }
}

extension SignupViewController: DataSourceObserverDelegate, StateObserverDelegate {
    var observerId: UUID {
        return id
    }

    func onDataSourceUpdated<T>(_ source: T?) {
        DispatchQueue.main.async(execute: rolePicker.reloadAllComponents)
    }

    func onLogin() {
        dismiss(animated: true, completion: nil)
    }

    func onLogout() { }
}
