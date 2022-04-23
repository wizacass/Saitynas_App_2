import UIKit

class AccessControllerBase: ViewWithKeyboardBase {

    let errorColor = UIColor.fromColorCode(.errorRed)
    let inputBorderColor = UIColor.fromColorCode(.inputFieldBorder)

    override func viewDidLoad(_ constraint: NSLayoutConstraint) {
        super.viewDidLoad(constraint)

        super.addKeyboardObservers()
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

    func handleError(_ error: ErrorDTO?) {
        guard let error = error else { return }

        let alert = UIAlertController.createAlert(
            error.title.formattedMessage,
            error.details?.formattedMessage
        )

        present(alert, animated: true, completion: nil)
    }
}
