import Foundation
import UIKit

class SignupViewModel {

    var selectedRoleId = 0
    var roles: [EnumDTO] = []

    private var observers: [DataSourceObserverDelegate?] = []

    private var communicator: Communicator

    init(_ communicator: Communicator) {
        self.communicator = communicator
    }

    func loadRoles() {
        communicator.getRoles(onSuccess: handleReceivedRoles) { _ in }
    }

    private func handleReceivedRoles(_ dto: EnumListDTO?) {
        guard let data = dto?.data else { return }

        roles = data
        observers.forEach { $0?.onDataSourceUpdated(roles) }
    }

    func signup(_ email: String, _ password: String) {
        print("Email: \(email)")
        print("Password: \(password)")
        print("Role: \(roles[selectedRoleId].name)")
    }
}

extension SignupViewModel: Observable {
    func subscribe(_ observer: ObserverDelegate) {
        if let observer = observer as? DataSourceObserverDelegate {
            observers.append(observer)
        }
    }

    func unsubscribe(_ observer: ObserverDelegate) {
        observers = observers.filter { $0?.observerId != observer.observerId }
    }
}
