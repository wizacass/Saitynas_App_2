import UIKit

extension UIPickerView {
    func enable() {
        self.isUserInteractionEnabled = true
        self.alpha = 1
    }

    func disable() {
        self.isUserInteractionEnabled = false
        self.alpha = 0.5
    }
}
