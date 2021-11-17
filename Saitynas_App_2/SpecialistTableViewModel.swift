import Foundation

class SpecialistTableViewModel {
    
    private var observers: [DataSourceObserverDelegate?] = []
    
    var count: Int {
        return specialists.count
    }
    
    private var communicator: Communicator
    private var specialists: [Specialist] = []
    
    init(_ communicator: Communicator) {
        self.communicator = communicator
        loadSpecialists()
    }
    
    private func loadSpecialists() {
        communicator.getSpecialists(onSuccess: handleSpecialistsReceived) { error in
            print("Specialists error received!")
            print(error?.title)
            print(error?.details ?? "")
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
