import UIKit

class PatientInfoViewController: AccessControllerBase {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad(bottomConstraint)
    }
}
