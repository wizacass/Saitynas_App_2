import UIKit

extension UIAlertController {

    static func createAlert(
        _ title: String,
        _ message: String? = nil,
        _ action: UIAlertAction? = nil
    ) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(action ?? createAlertAction())

        return alert
    }

    private static func createAlertAction() -> UIAlertAction {
        return UIAlertAction(
            title: "Ok",
            style: .default,
            handler: nil
        )
    }
}
