import UIKit

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private var viewModel: MessageViewModel!
    private var jwtUser: JwtUser!

    private let id = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()

        viewModel.loadMessage()
    }

    private func initialize() {
        let c = DIContainer.shared

        jwtUser = c.jwtUser
        viewModel = MessageViewModel(c.communicator, viewController: self)

        c.authenticationManager.subscribe(self)
    }
}

extension AuthenticationViewController: MessageViewControllerProtocol {
    func showMessage(_ message: String) {
        titleLabel.text = message
    }
    
    func showError(_ error: ErrorDTO) {
        print("Error!")
        print(error.title)
    }
}

extension AuthenticationViewController: StateObserverDelegate {
    var observerId: UUID {
        return id
    }

    private func selectNextViewIdentifier(_ user: User?) -> ViewControllerIdentifier? {
        guard
            let user = user,
            let role = Role(rawValue: user.role)
        else { return nil }

        switch role {
        case .patient:
            return user.hasProfile ? .patientTabBarViewController : .patientInformationViewController
        case .specialist:
            return  .specialistTabBarViewController
        }
    }

    func onLogin(_ user: User?) {
        guard
            let identifier = selectNextViewIdentifier(user),
            let viewController = storyboard?.instantiateViewController(identifier)
        else { return }

        navigationController?.pushViewController(viewController, animated: true)
    }

    func onLogout() { }
}
