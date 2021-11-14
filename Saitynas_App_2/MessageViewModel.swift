import Foundation

class MessageViewModel {

    private weak var delegate: MessageViewControllerProtocol?

    var message: String? {
        didSet {
            delegate?.showMessage(message ?? "")
        }
    }

    init(viewController delegate: MessageViewControllerProtocol) {
        self.delegate = delegate
    }

    func loadMessage() {
        message = "Yeet!"
    }
}
