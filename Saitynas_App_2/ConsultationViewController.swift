import UIKit
import AgoraRtcKit

class ConsultationViewController: UIViewController {

    @IBOutlet weak var agoraParentView: UIView!

    private var localView: UIView!
    private var remoteView: UIView!

    private var agoraKit: AgoraRtcEngineKit?
    private var consultationsService: ConsultationsService?
    private var communicator: Communicator?
    private var preferences: UserPreferences?
    private var jwtUser: JwtUser?

    private let minimumLocalViewWidth: CGFloat = 120.0
    private let agoraUid: UInt = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        initializeAgoraView()

        tryLoadingCall()
    }

    private func initialize() {
        let c = DIContainer.shared

        consultationsService = c.consultationsService
        communicator = c.communicator
        preferences = c.preferences
        jwtUser = c.jwtUser
    }

    private func initializeAgoraView() {
        remoteView = UIView()
        agoraParentView.addSubview(remoteView)

        localView = UIView()
        agoraParentView.addSubview(localView)
    }

    private func tryLoadingCall() {
        guard let channelId = preferences?.consultationId else { return }

        communicator?.getAgoraToken(
            channelId,
            onSuccess: initializeAndJoinChannel,
            onError: { error in
                print("Error in retrieving Agora token: \(error?.title ?? "FATAL ERROR")")
            })
    }

    func initializeAndJoinChannel(_ settings: AgoraSettingsDTO?) {
        guard let settings = settings?.data else { return }

        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "79ad8034ba7441fe8285f4aeb038384b", delegate: self)

        agoraKit?.enableVideo()

        let videoCanvas = createAgoraCanvas(localView, uid: agoraUid)
        agoraKit?.setupLocalVideo(videoCanvas)

        agoraKit?.joinChannel(
            byToken: settings.token,
            channelId: settings.channel,
            info: nil,
            uid: agoraUid,
            joinSuccess: { (_, _, _) in }
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let bounds = agoraParentView.bounds
        let width = max(bounds.width / 4.0, minimumLocalViewWidth)
        let height = width / 3.0 * 4.0

        remoteView.frame = bounds
        localView.frame = CGRect(
            x: bounds.width - width,
            y: 0,
            width: width,
            height: height
        )
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        agoraKit?.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
    }

    @IBAction func endConsultationPressed(_ sender: UIButton) {
        endConsultation()
    }

    private func endConsultation() {
        consultationsService?.endConsultation(onSuccess: handleConsultationEnded)
    }

    private func handleConsultationEnded() {
        if jwtUser?.role != .patient {
            exit()
            return
        }

        agoraKit?.leaveChannel(nil)

        let alert = UIAlertController.createAlert(
            "Thank you for consulting!",
            "Would you like to leave a review?",
            UIAlertAction(title: "No", style: .destructive, handler: { [weak self] _ in
                self?.exit()
            }))

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            if let viewController = self?.storyboard?.instantiateViewController(.createEvaluationViewController)
                as? CreateEvaluationViewController {
                viewController.viewModel = CreateReviewViewModel(self?.communicator, self?.preferences?.consultationId)

                self?.present(viewController, animated: true, completion: nil)
            }

            self?.navigationController?.popViewController(animated: true)
        }))

        present(alert, animated: true)
    }

    private func exit() {
        preferences?.consultationId = nil
        navigationController?.popViewController(animated: true)
    }

    private func createAgoraCanvas(_ view: UIView, uid: UInt) -> AgoraRtcVideoCanvas {
        let videoCanvas = AgoraRtcVideoCanvas()

        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = view

        return videoCanvas
    }
}

extension ConsultationViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let videoCanvas = createAgoraCanvas(remoteView, uid: uid)

        agoraKit?.setupRemoteVideo(videoCanvas)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        endConsultation()
    }
}
