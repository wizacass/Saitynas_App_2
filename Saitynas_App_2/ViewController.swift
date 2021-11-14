import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private var viewModel: MessageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        viewModel = MessageViewModel(appDelegate.container.communicator, viewController: self)
        viewModel.loadMessage()
    }
}

extension ViewController: MessageViewControllerProtocol {
    func showMessage(_ message: String) {
        titleLabel.text = message
    }
    
    func showError(_ error: Error) {
        print("Error!")
        print(error.title)
    }
}
