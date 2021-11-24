import UIKit

extension UIColor {
    static func fromColorCode(_ colorCode: ColorCode) -> UIColor? {
        return UIColor.init(named: colorCode.rawValue)
    }
}
