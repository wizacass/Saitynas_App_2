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
        return isLoggedIn ?
        storyboard?.instantiateViewController(.patientTabBarViewController) :
        storyboard?.instantiateViewController(.authenticationViewController)
    }
}
