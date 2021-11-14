import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!

    private var viewModel: MessageViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = MessageViewModel(viewController: self)

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        titleLabel.text = appDelegate.container.apiUrl
        viewModel.loadMessage()
    }
}

extension ViewController: MessageViewControllerProtocol {
    func showMessage(_ message: String) {
        titleLabel.text = message
    }

    func showError() { }
}
