import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var activityToggleView: ShadowView!
    @IBOutlet weak var activitySwitch: UISwitch!
    @IBOutlet weak var activityStatusLabel: UILabel!

    @IBOutlet weak var emailLabel: UILabel!

    private weak var authenticationManager: AuthenticationManager!

    private var viewModel: SettingsViewModel?

    private let id = UUID()

    override func viewDidLoad() {
        super.viewDidLoad()

        activitySwitch.isEnabled = false

        initialize()
    }

    private func initialize() {
        let c = DIContainer.shared

        viewModel = SettingsViewModel(c.communicator)
        viewModel?.subscribe(self)

        authenticationManager = c.authenticationManager

        activityToggleView.isHidden = c.jwtUser.role != Role.specialist
        emailLabel.text = c.jwtUser.email ?? "Failed to get email!"

        viewModel?.retrieveActivityStatuses(onError: { _ in })
        viewModel?.retrieveUserActivityStatus(onError: { _ in })
    }

    @IBAction func activitySwitchToggled(_ sender: UISwitch) {
        activityStatusLabel.text = "Loading..."

        viewModel?.updateUserActivityStatus(willGoOnline: sender.isOn, onError: { _ in })
    }

    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        authenticationManager.logout()
    }
}

extension SettingsViewController: DataSourceObserverDelegate {
    var observerId: UUID {
        return id
    }

    func onDataSourceUpdated<T>(_ source: T?) {
        guard let status = source as? EnumDTO else { return }

        activitySwitch.isEnabled = true
        activityStatusLabel.text = status.name
        activitySwitch.isOn = status.id == viewModel?.onlineStatusId
    }
}
