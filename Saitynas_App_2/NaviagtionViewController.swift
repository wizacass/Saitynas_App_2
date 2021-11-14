import Foundation
import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadApp()
    }

    private func loadApp() {
        if let vc = selectViewController(true) {
            viewControllers.append(vc)
        }
    }

    private func selectViewController(_ isLoggedIn: Bool) -> UIViewController? {
        return isLoggedIn ?
        storyboard?.instantiateViewController(.patientTabBarViewController) :
        storyboard?.instantiateViewController(.authenticationViewController)
    }
}
