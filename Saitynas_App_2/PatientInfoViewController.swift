import UIKit

class PatientInfoViewController: AccessControllerBase {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    private var authenticationManager: AuthenticationManager?
    private var communicator: Communicator?

    private let id = UUID()

    override func viewDidLoad() {
        super.viewDidLoad(bottomConstraint)

        initialize()
    }

    private func initialize() {
        let c = DIContainer.shared

        authenticationManager = c.authenticationManager
        communicator = c.communicator
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
