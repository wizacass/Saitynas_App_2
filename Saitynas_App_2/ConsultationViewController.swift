import UIKit
import AgoraRtcKit

class ConsultationViewController: UIViewController {

    @IBOutlet weak var agoraParentView: UIView!

    private var localView: UIView!
    private var remoteView: UIView!

    private var agoraKit: AgoraRtcEngineKit?
    private var consultationsService: ConsultationsService?

    override func viewDidLoad() {
        super.viewDidLoad()

        consultationsService = DIContainer.shared.consultationsService

        agoraParentView.backgroundColor = .magenta

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
        // Pass in your App ID here
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "79ad8034ba7441fe8285f4aeb038384b", delegate: self)

        // Video is disabled by default. You need to call enableVideo to start a video stream.
        agoraKit?.enableVideo()

        // Create a videoCanvas to render the local video
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        videoCanvas.view = localView
        agoraKit?.setupLocalVideo(videoCanvas)

        // Join the channel with a token. Pass in your token and channel name here
        agoraKit?.joinChannel(
            byToken: "00679ad8034ba7441fe8285f4aeb038384bIAByfPWJLO4I0TaGJVKFgkcIB49giCyjWAkQPw1JGG3EDAx+f9gAAAAAEACKbcvBh2RgYgEAAQCFZGBi",
            channelId: "test",
            info: nil,
            uid: 0,
            joinSuccess: { (channel, uid, elapsed) in
            })
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        remoteView.frame = agoraParentView.bounds
        localView.frame = CGRect(x: agoraParentView.bounds.width - 90, y: 0, width: 90, height: 160)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        agoraKit?.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
    }

    @IBAction func endConsultationPressed(_ sender: UIButton) {
        consultationsService?.endConsultation { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension ConsultationViewController: AgoraRtcEngineDelegate {
    // This callback is triggered when a remote user joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        agoraKit?.setupRemoteVideo(videoCanvas)
    }
}
