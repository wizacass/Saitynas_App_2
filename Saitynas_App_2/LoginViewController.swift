import UIKit

class LoginViewController: AccessControllerBase {
    
    @IBOutlet weak var emailTextField: InputField!
    @IBOutlet weak var emailErrorLabel: UILabel!

    @IBOutlet weak var passwordTextField: InputField!
    @IBOutlet weak var passwordErrorLabel: UILabel!

    @IBOutlet weak var loginButton: PrimaryButton!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    private var viewModel: LoginViewModel!
    private var authenticationManager: AuthenticationManager!

    private let id = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad(bottomConstraint)

        loginButton.disable()

        viewModel = LoginViewModel(viewController: self)

        authenticationManager = DIContainer.shared.authenticationManager
        authenticationManager.subscribe(self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        authenticationManager.unsubscribe(self)

        super.viewDidDisappear(animated)
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
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }

        authenticationManager.login(email, password, onError: handleLoginError)
    }

    private func handleLoginError(_ error: ErrorDTO?) {
        guard let error = error else { return }

        let alert = UIAlertController.createAlert(
            error.title.formattedMessage,
            error.details?.formattedMessage
        )

        present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: AuthenticationViewControllerProtocol {
    func enableAction() { loginButton.enable() }

    func disableAction() { loginButton.disable() }

    func setEmailError(_ error: String?) {
        emailErrorLabel.text = error
    }

    func setPasswordError(_ error: String?) {
        passwordErrorLabel.text = error
    }
}

extension LoginViewController: StateObserverDelegate {
    var observerId: UUID {
        return id
    }

    func onLogin(_ user: User?) {
        dismiss(animated: true, completion: nil)
    }

    func onLogout() { }
}
