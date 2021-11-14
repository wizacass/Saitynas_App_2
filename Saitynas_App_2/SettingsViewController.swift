import UIKit

class SettingsViewController: UIViewController {

    private var authenticationManager: AuthenticationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        authenticationManager = DIContainer.shared.authenticationManager
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        authenticationManager.logout()
    }
}
