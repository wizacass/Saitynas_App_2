import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var authenticationManager: AuthenticationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticationManager = DIContainer.shared.authenticationManager
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }
        
        authenticationManager.login(email, password) { [weak self] error in
            if let error = error {
                print("Login error!")
                print(error.title)
                return
            }
            
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
