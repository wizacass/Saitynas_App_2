import UIKit

class ConsultationSearchViewController: UIViewController {

    private var notificationService: RemoteNotificationsService?
    private var consultationsService: ConsultationsService?

    private let id = UUID()

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    private func initialize() {
        let c = DIContainer.shared

        notificationService = c.notificationsService
        consultationsService = c.consultationsService
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

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        consultationsService?.cancelConsultation { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
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
