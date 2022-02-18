import UIKit

class AccessControllerBase: UIViewController {

    let errorColor = UIColor.fromColorCode(.errorRed)
    let inputBorderColor = UIColor.fromColorCode(.inputFieldBorder)

    private weak var bottomConstraint: NSLayoutConstraint?

    private var defaultConstraintDistance: CGFloat!

    private let distanceFromKeyboard: CGFloat = 16

    func viewDidLoad(_ constraint: NSLayoutConstraint) {
        super.viewDidLoad()

        bottomConstraint = constraint
        defaultConstraintDistance = constraint.constant
        addKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Keyboard Observers
extension AccessControllerBase {
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo

        guard
            let keyboardSize = getKeyboardSize(info),
            let duration = getKeyboardAnimationDuration(info)
        else { return }

        let distance = keyboardSize - bottomLayoutGuide.length + distanceFromKeyboard
        bottomConstraint?.constant = distance

        UIView.animate(
            withDuration: duration,
            animations: view.layoutIfNeeded
        )
    }

    @objc private func keyboardWillHide(sender: NSNotification) {
        guard let duration = getKeyboardAnimationDuration(sender.userInfo) else {
            return
        }

        bottomConstraint?.constant = defaultConstraintDistance

        UIView.animate(
            withDuration: duration,
            animations: view.layoutIfNeeded
        )
    }

    private func getKeyboardSize(_ userInfo: [AnyHashable: Any]?) -> CGFloat? {
        let frame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
        return (frame as? NSValue)?.cgRectValue.height
    }

    private func getKeyboardAnimationDuration(_ userInfo: [AnyHashable: Any]?) -> TimeInterval? {
        let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
        return (duration as? NSNumber)?.doubleValue
    }
}
