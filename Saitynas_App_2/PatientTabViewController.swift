import UIKit

class PatientTabViewController: UserTabViewController {

    private weak var consultationsService: ConsultationsService?
    private weak var preferences: UserPreferences?
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
        preferences = c.preferences
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

        notificationCenter.addObserver(
            self,
            selector: #selector(appWillTerminate),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
    }

    @objc func appCameToForeground() {
        DispatchQueue.global(qos: .userInteractive).asyncAfter(
            deadline: .now() + DispatchTimeInterval.seconds(1),
            execute: tryStartConsultation
        )
    }

    @objc func appWillTerminate() {
        tryEndConsultation()
    }

    private func tryStartConsultation() {
        guard let consultationId = preferences?.consultationId else { return }

        if !shouldAttemptRequest(consultationId) { return }

        consultationsService?.startConsultation(onSuccess: handleConsultationStarted)
    }

    private func handleConsultationStarted() {
        if let viewController = storyboard?.instantiateViewController(.consultationViewController) {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    private func tryEndConsultation() {
        guard let consultationId = preferences?.consultationId else { return }

        if !shouldAttemptRequest(consultationId) { return }

        let sem = DispatchSemaphore(value: 0)
        consultationsService?.endConsultation { sem.signal() }
        sem.wait()
    }

    private func shouldAttemptRequest(_ consultationId: Int) -> Bool {
        return consultationId != 0 && jwtUser?.role == .patient
    }
}

extension PatientTabViewController: DataSourceObserverDelegate {
    var observerId: UUID {
        return id
    }

    func onDataSourceUpdated<T>(_ source: T?) {
        tryStartConsultation()
    }
}
