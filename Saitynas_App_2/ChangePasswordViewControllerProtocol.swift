import Foundation

protocol ChangePasswordViewControllerProtocol: AnyObject {
    func enableAction()
    func disableAction()

    func setCurrentPasswordError(_ error: String?)
    func setNewPasswordError(_ error: String?)
}
