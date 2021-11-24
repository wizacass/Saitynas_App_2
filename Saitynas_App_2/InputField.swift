import UIKit

@IBDesignable class InputField: UITextField {

    private let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderWidth: Int = 1 {
        didSet {
            layer.borderWidth = CGFloat(borderWidth)
        }
    }

    @IBInspectable var borderColor: UIColor? = UIColor.black {
        didSet {
            layer.borderColor = borderColor?.resolvedColor(with: traitCollection).cgColor
        }
    }

    var isEmpty: Bool {
        self.text?.isEmpty ?? true
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
