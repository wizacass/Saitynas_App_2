import UIKit

class LoginViewController: AccessControllerBase {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    private var authenticationManager: AuthenticationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad(bottomConstraint)
        
        authenticationManager = DIContainer.shared.authenticationManager
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }
        
        authenticationManager.login(email, password) { [weak self] error in
            if let error = error {
                let alert = UIAlertController(
                    title: "Login error!",
                    message: error.title.formattedMessage,
                    preferredStyle: .alert
                )

                let alertAction = UIAlertAction(
                    title: "Ok",
                    style: .default,
                    handler: nil
                )
                alert.addAction(alertAction)

                self?.present(alert, animated: true, completion: nil)

                return
            }
            
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
