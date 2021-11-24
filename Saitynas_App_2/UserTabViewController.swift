import UIKit

class UserTabViewController: UITabBarController, StateObserverDelegate {
    var observerId: UUID {
        return id
    }
    
    private weak var authenticationManager: AuthenticationManager?

    private let id = UUID()

    override func viewDidLoad() {
        super.viewDidLoad()

        authenticationManager = DIContainer.shared.authenticationManager
        authenticationManager?.subscribe(self)
    }

    private var hasControllerInStack: Bool {
        guard let count = navigationController?.viewControllers.count else {
            return false
        }

        return count > 1
    }

    func onLogin() { }

    func onLogout() {
        authenticationManager?.unsubscribe(self)

        let hasController = hasControllerInStack
        navigationController?.popViewController(animated: true)

        if hasController { return }
        if let viewController = storyboard?.instantiateViewController(.authenticationViewController) {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
