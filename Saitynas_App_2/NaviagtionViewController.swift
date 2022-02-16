import Foundation
import UIKit

class NavigationViewController: UINavigationController {

    private var c: DIContainer!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadApp()
    }

    private func loadApp() {
        c = DIContainer.shared

        if let vc = selectViewController() {
            viewControllers.append(vc)
        }
    }

    private func selectViewController() -> UIViewController? {
        let user = c.jwtUser
        let hasProfile = c.preferences.hasProfile

        let identifier = selectNextViewIdentifier(user, hasProfile: hasProfile)

        return storyboard?.instantiateViewController(identifier)
    }

    private func selectNextViewIdentifier(_ user: JwtUser?, hasProfile: Bool) -> ViewControllerIdentifier {
        switch user?.role {
        case .patient:
            return hasProfile ? .patientTabBarViewController : .patientInformationViewController
        case .specialist:
            return  .specialistTabBarViewController
        case .none:
            return .authenticationViewController
        }
    }
}
