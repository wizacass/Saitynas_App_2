import Foundation

class MessageViewModel {
    
    private var communicator: Communicator
    
    private weak var delegate: MessageViewControllerProtocol?
    
    var message: String? {
        didSet {
            guard let message = message else { return }
            
            delegate?.showMessage(message)
        }
    }
    
    var error: ErrorDTO? {
        didSet {
            guard let error = error else { return }
            
            delegate?.showError(error)
        }
    }
    
    init(
        _ communicator: Communicator,
        viewController delegate: MessageViewControllerProtocol
    ) {
        self.communicator = communicator
        self.delegate = delegate
    }
    
    func loadMessage() {
        communicator.getMessage() { [weak self] messageDto in
            if let message = messageDto?.data.message {
                self?.message = message
            } else {
                print("Serialization error!")
            }
            
        } onError: { [weak self] error in
            self?.error = error
        }
    }
}
