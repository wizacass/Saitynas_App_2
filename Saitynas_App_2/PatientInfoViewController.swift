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

    override func viewWillAppear(_ animated: Bool) {
        authenticationManager?.subscribe(self)

        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        authenticationManager?.unsubscribe(self)

        super.viewDidDisappear(animated)
    }

    @IBAction func submitButtonPressed(_ sender: UIButton) {
        guard
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let city = cityTextField.text
        else { return }

        let patient = Patient(firstName, lastName, birthDatePicker.date, city)
        
        communicator?.createPatient(patient, onSuccess: { [weak self] _ in
            self?.userPreferences?.hasProfile = true
            if let viewController = self?.storyboard?.instantiateViewController(.patientTabBarViewController) {
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        }, onError: handleError)
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

extension PatientInfoViewController: StateObserverDelegate {
    func onLogin(_ user: User?) { }

    func onLogout() {
        let hasController = hasControllerInStack
        navigationController?.popViewController(animated: true)

        if hasController { return }
        if let viewController = storyboard?.instantiateViewController(.authenticationViewController) {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    private var hasControllerInStack: Bool {
        guard let count = navigationController?.viewControllers.count else {
            return false
        }

        return count > 1
    }

    var observerId: UUID {
        return id
    }
}
