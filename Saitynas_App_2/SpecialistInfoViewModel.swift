import Foundation

class SpecialistInfoViewModel {

    var selectedSpecialityIndex = 0
    var speciality: [EnumDTO] = []

    private var observers: [DataSourceObserverDelegate?] = []

    private var communicator: Communicator
    private var userPreferences: UserPreferences

    init(
        _ communicator: Communicator,
        _ userPreferences: UserPreferences
    ) {
        self.communicator = communicator
        self.userPreferences = userPreferences
    }

    func loadRoles() {
        communicator.getSpecialities(onSuccess: handleReceivedRoles) { _ in }
    }

    private func handleReceivedRoles(_ dto: EnumListDTO?) {
        guard let data = dto?.data else { return }

        speciality = data
        observers.forEach { $0?.onDataSourceUpdated(speciality) }
    }

    func createPatient(
        _ firstName: String, _ lastName: String, _ city: String,
        onSuccess: @escaping () -> Void,
        onError handleError: @escaping (ErrorDTO?) -> Void
    ) {
        let specialist = CreateSpecialistDTO(
            firstName: firstName,
            lastName: lastName,
            city: city,
            specialityId: speciality[selectedSpecialityIndex].id
        )

        communicator.createSpecialist(specialist, onSuccess: { [weak self] _ in
            self?.userPreferences.hasProfile = true
            DispatchQueue.main.async(execute: onSuccess)
        }, onError: handleError)
    }
}

extension SpecialistInfoViewModel: Observable {
    func subscribe(_ observer: ObserverDelegate) {
        if let observer = observer as? DataSourceObserverDelegate {
            observers.append(observer)
        }
    }

    func unsubscribe(_ observer: ObserverDelegate) {
        observers = observers.filter { $0?.observerId != observer.observerId }
    }
}
