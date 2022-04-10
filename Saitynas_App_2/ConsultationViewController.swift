import UIKit

class ConsultationViewController: UIViewController {

    @IBOutlet weak var consultationIdLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let preferences = DIContainer.shared.preferences
        consultationIdLabel.text = "Consultation id: \(preferences.consultationId ?? -1)"
    }

    @IBAction func endConsultationPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
