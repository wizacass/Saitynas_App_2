import Foundation
import UIKit

extension UIButton {
    func setTitleColor(_ colorCode: ColorCode) {
        let color = UIColor.fromColorCode(colorCode)
        self.setTitleColor(color, for: .normal)
    }

    func setBackgroundColor(_ colorCode: ColorCode) {
        let color = UIColor.fromColorCode(colorCode)
        configuration?.background.backgroundColor = color
    }
}
