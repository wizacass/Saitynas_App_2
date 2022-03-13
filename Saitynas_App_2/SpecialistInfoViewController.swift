import UIKit

class SpecialistInfoViewController: AccessControllerBase {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad(bottomConstraint)
    }
}
