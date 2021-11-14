import UIKit

extension UIStoryboard {
    func instantiateViewController(_ identifier: ViewControllerIdentifier) -> UIViewController? {
        return instantiateViewController(withIdentifier: identifier.rawValue)
    }
}
