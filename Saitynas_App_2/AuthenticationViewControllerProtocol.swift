import Foundation

protocol AuthenticationViewControllerProtocol: AnyObject {
    func enableAction()
    func disableAction()

    func setEmailError(_ error: String?)
    func setPasswordError(_ error: String?)
}
