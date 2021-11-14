import UIKit

class PatientTabViewController: UITabBarController {
    
    private weak var authenticationManager: AuthenticationManager?
    
    private let id = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticationManager = DIContainer.shared.authenticationManager
        authenticationManager?.subscribe(self)
    }
}

extension PatientTabViewController: StateObserverDelegate {
    var observerId: UUID {
        return id
    }
    
    func onLogin() { }
    
    func onLogout() {
        authenticationManager?.unsubscribe(self)
        navigationController?.popViewController(animated: true)
    }
}
