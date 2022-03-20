import UIKit
import UserNotifications

class RemoteNotificationsService {

    private var tokensRepository: UserTokensRepository

    private var observers: [DataSourceObserverDelegate?] = []

    private let notificationOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
    private let notificationCenter = UNUserNotificationCenter.current()

    init(_ tokensRepository: UserTokensRepository) {
        self.tokensRepository = tokensRepository
    }

    func registerForPushNotifications() {
        notificationCenter.requestAuthorization(options: notificationOptions) { [weak self] granted, _ in
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }

    private func getNotificationSettings() {
        notificationCenter.getNotificationSettings() { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func saveToken(_ deviceToken: String) {
        tokensRepository.deviceToken = deviceToken
    }

    func handleReceivedNotification() {
        observers.forEach { $0?.onDataSourceUpdated(NullObject.instance) }
    }
}

extension RemoteNotificationsService: Observable {
    func subscribe(_ observer: ObserverDelegate) {
        if let observer = observer as? DataSourceObserverDelegate {
            observers.append(observer)
        }
    }

    func unsubscribe(_ observer: ObserverDelegate) {
        observers = observers.filter { $0?.observerId != observer.observerId }
    }
}
