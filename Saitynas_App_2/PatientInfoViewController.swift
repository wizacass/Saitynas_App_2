import UIKit

class PatientInfoViewController: AccessControllerBase {

    @IBOutlet weak var firstNameTextField: InputField!
    @IBOutlet weak var lastNameTextField: InputField!
    @IBOutlet weak var cityTextField: InputField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!

    @IBOutlet weak var submitButton: PrimaryButton!
    @IBOutlet weak var laterButton: UIButton!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    private var authenticationManager: AuthenticationManager?
    private var communicator: Communicator?
    private var userPreferences: UserPreferences?

    private let id = UUID()

    override func viewDidLoad() {
        super.viewDidLoad(bottomConstraint)

        initialize()
    }

    private func initialize() {
        let c = DIContainer.shared

        authenticationManager = c.authenticationManager
        communicator = c.communicator
        userPreferences = c.preferences
    }

    @IBAction func submitButtonPressed(_ sender: UIButton) {
        guard
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let city = cityTextField.text
        else { return }

        let patient = Patient(firstName, lastName, birthDatePicker.date, city)
        
        communicator?.createPatient(patient, onSuccess: handlePatientCreated, onError: handleError)
    }

    private func handlePatientCreated(_ obj: NullObject?) {
        userPreferences?.hasProfile = true
        if let viewController = storyboard?.instantiateViewController(.patientTabBarViewController) {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    private func handleError(_ error: ErrorDTO?) {
        guard let error = error else { return }

        let alert = UIAlertController.createAlert(
            error.title.formattedMessage,
            error.details?.formattedMessage
        )

        present(alert, animated: true, completion: nil)
    }

    @IBAction func laterButtonPressed(_ sender: UIButton) {
        authenticationManager?.logout()
    }
}
