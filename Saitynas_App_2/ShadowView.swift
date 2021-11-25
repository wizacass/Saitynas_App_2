import UIKit

@IBDesignable class ShadowView: UIView {

    @IBInspectable var hasShadow: Bool = false
    @IBInspectable var shadowHeight: CGFloat = 0
    @IBInspectable var shadowRadius: CGFloat = 4
    @IBInspectable var shadowColor: UIColor = .black
    @IBInspectable var cornerRadius: CGFloat = 0

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if hasShadow {
            applyShadow()
        }
    }

    private func applyShadow() {
        let shadowRect = CGRect(
            x: bounds.minX,
            y: bounds.minY,
            width: bounds.width,
            height: bounds.height + shadowHeight
        )

        layer.shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: cornerRadius).cgPath
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
        layer.shadowColor = shadowColor.resolvedColor(with: traitCollection).cgColor
    }
}
