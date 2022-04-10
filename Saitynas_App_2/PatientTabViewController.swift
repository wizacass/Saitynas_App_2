import UIKit

class PatientTabViewController: UserTabViewController {

    private let id = UUID()
    private let notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()

        DIContainer.shared.notificationsService.subscribe(self)
        subscribeToBackgroundNotifiactions()
    }

    private func subscribeToBackgroundNotifiactions() {
        notificationCenter.addObserver(
            self,
            selector: #selector(appCameToForeground),
            name: UIApplication.willEnterForegroundNotification, object: nil
        )
    }

    @objc func appCameToForeground() {
        print("App came to foreground!")

        // TODO: - Check for a consultation
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
