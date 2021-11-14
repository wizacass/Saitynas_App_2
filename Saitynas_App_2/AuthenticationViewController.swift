import UIKit

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private var viewModel: MessageViewModel!

    private let id = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DIContainer.shared.authenticationManager.subscribe(self)

        viewModel = MessageViewModel(DIContainer.shared.communicator, viewController: self)
        viewModel.loadMessage()
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

    func onLogin() {
        if let viewController = storyboard?.instantiateViewController(.patientTabBarViewController) {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func onLogout() { }
}
