import UIKit

class ConsultationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func endConsultationPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
