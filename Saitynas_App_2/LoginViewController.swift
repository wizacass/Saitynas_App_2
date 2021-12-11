import UIKit

class LoginViewController: AccessControllerBase {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var authenticationManager: AuthenticationManager!
    
    private let id = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad(bottomConstraint)
        
        authenticationManager = DIContainer.shared.authenticationManager
        authenticationManager.subscribe(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        authenticationManager.unsubscribe(self)
        
        super.viewDidDisappear(animated)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }
        
        authenticationManager.login(email, password) { [weak self] error in
            guard let error = error else { return }
            
            let alert = UIAlertController.createAlert(
                error.title.formattedMessage,
                error.details?.formattedMessage
            )
            
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

extension LoginViewController: StateObserverDelegate {
    var observerId: UUID {
        return id
    }
    
    func onLogin() {
        dismiss(animated: true, completion: nil)
    }
    
    func onLogout() { }
}
