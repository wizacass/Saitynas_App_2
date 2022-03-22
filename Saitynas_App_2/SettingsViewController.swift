import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var activityToggleView: ShadowView!
    @IBOutlet weak var activityStatusLabel: UILabel!

    @IBOutlet weak var emailLabel: UILabel!

    private weak var authenticationManager: AuthenticationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    private func initialize() {
        let c = DIContainer.shared

        authenticationManager = c.authenticationManager

        activityToggleView.isHidden = c.jwtUser.role != Role.specialist
        emailLabel.text = c.jwtUser.email ?? "Failed to get email!"
    }

    @IBAction func activitySwitchToggled(_ sender: UISwitch) {
        activityStatusLabel.text = sender.isOn ? "Available" : "Busy"
    }

    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        authenticationManager.logout()
    }
}
