import Foundation
import UIKit

class NavigationViewController: UINavigationController {

    private var c: DIContainer!

    private let id = UUID()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadApp()
    }

    private func loadApp() {
        c = DIContainer.shared
        c.authenticationManager.subscribe(self)

        if let vc = selectViewController() {
            viewControllers.append(vc)
        }
    }

    private func selectViewController() -> UIViewController? {
        let user = c.jwtUser
        let hasProfile = c.preferences.hasProfile

        let identifier = selectNextViewIdentifier(user.role, hasProfile)

        return storyboard?.instantiateViewController(identifier)
    }

    private func selectNextViewIdentifier(_ role: Role?, _ hasProfile: Bool) -> ViewControllerIdentifier {
        switch role {
        case .patient:
            return hasProfile ? .patientTabBarViewController : .patientInformationViewController
        case .specialist:
            return hasProfile ? .specialistTabBarViewController : .specialistInformationViewController
        case .none:
            return .authenticationViewController
        }
    }
}

extension NavigationViewController: StateObserverDelegate {
    var observerId: UUID {
        return id
    }

    private var getAuthController: UIViewController? {
        if let controller = viewControllers.first(where: { $0 is AuthenticationViewController }) {
            return controller
        }

        return storyboard?.instantiateViewController(.authenticationViewController)
    }

    func onLogin(_ user: User?) {
        guard
            let user = user,
            let role = Role(rawValue: user.role)
        else { return }

        let identifier = selectNextViewIdentifier(role, user.hasProfile)

        if let viewController = storyboard?.instantiateViewController(identifier) {
            pushViewController(viewController, animated: true)
        }
    }

    func onLogout() {
        guard let controller = getAuthController else { return }

        setViewControllers([controller], animated: true)
    }
}
