import Foundation

class SpecialistTableViewModel {

    var count: Int {
        return specialists.count
    }
    
    private var communicator: Communicator
    private var specialists: [Specialist] = []
    private var workplaceId: Int?

    private var observers: [DataSourceObserverDelegate?] = []
    
    init(_ communicator: Communicator, workplaceId: Int? = nil) {
        self.communicator = communicator
        self.workplaceId = workplaceId
    }
    
    func loadSpecialists() {
        if let workplaceId = workplaceId {
            communicator.getWorkplaceSpecialists(workplaceId, onSuccess: handleSpecialistsReceived) { _ in }
        } else {
            communicator.getSpecialists(onSuccess: handleSpecialistsReceived) { _ in }
        }
    }
    
    private func handleSpecialistsReceived(_ dto: SpecialistsDTO?) {
        guard let data = dto?.data else { return }
        
        specialists = data
        
        observers.forEach { $0?.onDataSourceUpdated(NullObject.instance) }
    }
    
    func getSpecialist(at index: Int) -> Specialist {
        return specialists[index]
    }
}

extension SpecialistTableViewModel: Observable {
    func subscribe(_ observer: ObserverDelegate) {
        if let observer = observer as? DataSourceObserverDelegate {
            observers.append(observer)
        }
    }
    
    func unsubscribe(_ observer: ObserverDelegate) {
        observers = observers.filter { $0?.observerId != observer.observerId }
    }
}
