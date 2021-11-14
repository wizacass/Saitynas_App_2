import UIKit

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private var viewModel: MessageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MessageViewModel(DIContainer.shared.communicator ,viewController: self)
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
