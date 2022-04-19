import UIKit
import AgoraRtcKit

class ConsultationViewController: UIViewController {

    @IBOutlet weak var agoraParentView: UIView!

    private var localView: UIView!
    private var remoteView: UIView!

    private var agoraKit: AgoraRtcEngineKit?
    private var consultationsService: ConsultationsService?

    private let minimumLocalViewWidth: CGFloat = 120.0
    private let agoraUid: UInt = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        consultationsService = DIContainer.shared.consultationsService

        initAgoraView()

        initializeAndJoinChannel()
    }

    private func initAgoraView() {
        remoteView = UIView()
        agoraParentView.addSubview(remoteView)

        localView = UIView()
        agoraParentView.addSubview(localView)
    }

    func initializeAndJoinChannel() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "79ad8034ba7441fe8285f4aeb038384b", delegate: self)

        agoraKit?.enableVideo()

        let videoCanvas = createAgoraCanvas(localView, uid: agoraUid)
        agoraKit?.setupLocalVideo(videoCanvas)

        // Join the channel with a token. Pass in your token and channel name here
        agoraKit?.joinChannel(
            byToken: "00679ad8034ba7441fe8285f4aeb038384bIAByfPWJLO4I0TaGJVKFgkcIB49giCyjWAkQPw1JGG3EDAx+f9gAAAAAEACKbcvBh2RgYgEAAQCFZGBi",
            channelId: "test",
            info: nil,
            uid: agoraUid,
            joinSuccess: { (channel, uid, elapsed) in
            })
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
        consultationsService?.endConsultation { [weak self] in
            self?.navigationController?.popViewController(animated: true)
            // TODO: Push review alert
        }
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
