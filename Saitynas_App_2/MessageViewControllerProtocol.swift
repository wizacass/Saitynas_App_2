import Foundation

protocol MessageViewControllerProtocol: AnyObject {

    func showMessage(_ message: String)
    func showError(_ error: ErrorDTO)
}
