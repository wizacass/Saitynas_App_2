import UIKit

extension UIViewController {
    func isOf(type identifier: ViewControllerIdentifier) -> Bool {
        return self.restorationIdentifier == identifier.rawValue
    }
}
