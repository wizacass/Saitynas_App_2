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
