import UIKit

class ButtonWithShadow: UIButton {

    override func draw(_ rect: CGRect) {
        applyShadow()
    }

    func applyShadow() {
        self.layer.shadowColor = UIColor.fromColorCode(.shadow)?.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 4.0
        self.layer.masksToBounds = false
    }
}
