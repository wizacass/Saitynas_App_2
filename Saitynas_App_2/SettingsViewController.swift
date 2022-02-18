import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!

    private weak var authenticationManager: AuthenticationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    private func initialize() {
        let c = DIContainer.shared

        authenticationManager = c.authenticationManager
        emailLabel.text = c.jwtUser.email ?? "Failed to get email!"
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        authenticationManager.logout()
    }
}
