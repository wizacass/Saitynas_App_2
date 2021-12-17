import Foundation
import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadApp()
    }

    private func loadApp() {
        let isLoggedIn = DIContainer.shared.authenticationManager.isLoggedIn

        if let vc = selectViewController(isLoggedIn) {
            viewControllers.append(vc)
        }
    }

    private func selectViewController(_ isLoggedIn: Bool) -> UIViewController? {
        let user = DIContainer.shared.jwtUser

        switch user.role {
        case .patient:
            return storyboard?.instantiateViewController(.patientTabBarViewController)
        case .specialist:
            return storyboard?.instantiateViewController(.specialistTabBarViewController)
        default:
            return storyboard?.instantiateViewController(.authenticationViewController)
        }
    }
}
