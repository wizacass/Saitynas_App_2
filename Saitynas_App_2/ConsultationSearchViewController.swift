import UIKit

class ConsultationSearchViewController: UIViewController {

    private var notificationService: RemoteNotificationsService?

    private let id = UUID()

    override func viewDidLoad() {
        super.viewDidLoad()

        notificationService = DIContainer.shared.notificationsService
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
        notificationService?.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
        notificationService?.unsubscribe(self)
    }
}

extension ConsultationSearchViewController: DataSourceObserverDelegate {
    var observerId: UUID {
        return id
    }

    func onDataSourceUpdated<T>(_ source: T?) {
        navigationController?.popViewController(animated: false)
    }
}
