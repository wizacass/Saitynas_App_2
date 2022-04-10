import UIKit

class ConsultationViewController: UIViewController {

    @IBOutlet weak var consultationIdLabel: UILabel!

    private var consultationsService: ConsultationsService?

    override func viewDidLoad() {
        super.viewDidLoad()

        let preferences = DIContainer.shared.preferences
        consultationIdLabel.text = "Consultation id: \(preferences.consultationId ?? -1)"

        consultationsService = DIContainer.shared.consultationsService
    }

    @IBAction func endConsultationPressed(_ sender: UIButton) {
        consultationsService?.endConsultation { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
