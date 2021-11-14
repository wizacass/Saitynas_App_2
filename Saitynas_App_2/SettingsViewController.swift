import UIKit

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        if let viewController = storyboard?.instantiateViewController(.authenticationViewController) as? AuthenticationViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
