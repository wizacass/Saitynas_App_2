import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        titleLabel.text = appDelegate.container.apiUrl
    }
}
