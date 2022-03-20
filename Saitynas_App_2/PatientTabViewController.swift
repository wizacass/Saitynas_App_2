import UIKit

class PatientTabViewController: UserTabViewController {

    private let id = UUID()

    override func viewDidLoad() {
        super.viewDidLoad()

        DIContainer.shared.notificationsService.subscribe(self)
    }
}

extension PatientTabViewController: DataSourceObserverDelegate {
    var observerId: UUID {
        return id
    }

    func onDataSourceUpdated<T>(_ source: T?) {
        if let viewController = storyboard?.instantiateViewController(.consultationViewController) {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
