import UIKit

class SpecialistTabViewController: UserTabViewController {

    private weak var consultationsService: ConsultationsService?
    private weak var jwtUser: JwtUser?

    private let id = UUID()
    private let notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    private func initialize() {
        let c = DIContainer.shared

        consultationsService = c.consultationsService
        jwtUser = c.jwtUser

        c.notificationsService.subscribe(self)
        subscribeToBackgroundNotifiactions()
    }

    private func subscribeToBackgroundNotifiactions() {
        notificationCenter.addObserver(
            self,
            selector: #selector(appCameToForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    @objc func appCameToForeground() {
        print("App came to foreground!")
        DispatchQueue.global(qos: .userInteractive).asyncAfter(
            deadline: .now() + DispatchTimeInterval.seconds(1),
            execute: tryAcceptConsultation
        )
    }

    private func tryAcceptConsultation() {
        if jwtUser?.role != .specialist { return }

        print("Checking for consultation...")
        consultationsService?.acceptConsultation(onSuccess: handleConsultationAccepted)
    }

    private func handleConsultationAccepted() {
        if let viewController = storyboard?.instantiateViewController(.consultationViewController) {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension SpecialistTabViewController: DataSourceObserverDelegate {
    var observerId: UUID {
        return id
    }

    func onDataSourceUpdated<T>(_ source: T?) {
        displayConsultationAlert()
    }

    private func displayConsultationAlert() {
        let alert = UIAlertController(
            title: "A patient has requested consultation!",
            message: nil,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Not now", style: .destructive))
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { [weak self] _ in
            self?.tryAcceptConsultation()
        }))

        present(alert, animated: true)
    }
}
