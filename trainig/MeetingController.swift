//
//  Meeting.swift
//  trainig
//
//  Created by omer yildirim on 8.02.2025.
//

import UIKit
import AgoraRtcKit
import AVFAudio
import AVFoundation
import AVKit
class MeetingController: UIViewController {
    
    // Define the remoteView variable
    @IBOutlet weak var remoteView: UIView!
    @IBOutlet weak var localView: UIView!
    @IBOutlet weak var buttonGroup: NoBorderNoBack8!
    var token:String!
    var channel:String!
    var touched=false
    var bGroupPoints:CGPoint!
    // Declare a variable for the AgoraRtcEngineKit instance
    var agoraKit: AgoraRtcEngineKit!
    // Set up the video layout
    var pipController: AVPictureInPictureController?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(togglePiP), name: NSNotification.Name("StartPiP"), object: nil)

        UIApplication.shared.isIdleTimerDisabled = true
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        remoteView.addGestureRecognizer(gesture)
        bGroupPoints=buttonGroup.frame.origin
        // Create localView with a frame matching the screen bounds
        //remoteView = UIView(frame: UIScreen.main.bounds)
        // Create remoteView with a specific frame
        // Positioned on the top right corner with an offset of 50 points from the top
        //localView = UIView(frame: CGRect(x: self.view.bounds.width - 135, y: 50, width: 135, height: 240))
        localView.backgroundColor = UIColor.black
        
        //self.view.addSubview(remoteView)
        //self.view.addSubview(localView)
        // Initialize the AgoraRtcEngineKit instance with your App ID and and set the delegate to self
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "34f37b33b5724e179370163c04e069d6", delegate: self)
        // Enable the video module (audio module is enabled by default)
        agoraKit.enableVideo()
        // Start local camera preview
        //getCamPermissions()
        self.startPreview()
        preview=true
        localAudio=true
        // Join the channel
        joinChannel()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        localView.addGestureRecognizer(panGesture)
    }
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
           let translation = gesture.translation(in: self.view)
           if let view = gesture.view {
               view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
           }
           gesture.setTranslation(.zero, in: self.view)
       }
    var preview:Bool=false
    var localAudio:Bool=false
    @IBOutlet weak var micbtn: RoundedButton!
    @IBOutlet weak var cambtn: RoundedButton!
    @IBAction func abort(_ sender: Any) {
        agoraKit.stopPreview()
        agoraKit.leaveChannel()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func mic(_ sender: Any) {
        agoraKit.muteLocalAudioStream(localAudio)
        localAudio.toggle()
        micbtn.setImage(localAudio ? UIImage(systemName: "microphone.fill") : UIImage(systemName: "microphone.slash.fill"), for: .normal)
    }
    @IBAction func cam(_ sender: Any) {
        agoraKit.muteLocalVideoStream(preview)
        localView.isHidden=preview
        preview.toggle()
        cambtn.setImage(preview ? UIImage(systemName: "video.fill") : UIImage(systemName: "video.slash.fill"), for: .normal)
        
    }
    @IBAction func sw_cam(_ sender: Any) {
        agoraKit.switchCamera()
    }
    @objc func handleTap() {
        touched.toggle()
        UIView.animate(withDuration: 1.5) {
            self.buttonGroup.isHidden = self.touched
        }
        
        
    }
    func getCamPermissions() {
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            if granted {
                self.getMicPermissions()
            }
        }
    }
    func getMicPermissions() {
        
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                self.startPreview()
            }
            
        }
        
    }
    
    deinit {
        agoraKit.stopPreview()
        agoraKit.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
    }
    // Start the local camera preview
    func startPreview() {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.view = localView
        videoCanvas.renderMode = .hidden
        agoraKit.setupLocalVideo(videoCanvas)
        agoraKit.startPreview()
        setupPiP()
    }
    // Join the channel with specified options
    func joinChannel() {
        let options = AgoraRtcChannelMediaOptions()
        // Set the user role as broadcaster (default is audience)
        options.clientRoleType = .broadcaster
        // Publish audio captured by microphone
        options.publishMicrophoneTrack = true
        // Publish video captured by camera
        options.publishCameraTrack = true
        // Auto subscribe to all audio streams
        options.autoSubscribeAudio = true
        // Auto subscribe to all video streams
        options.autoSubscribeVideo = true
        // Use a temporary Token to join the channel
        // Replace <#Your Token#> and <#Your Channel Name#> with your project's Token and channel name
        // If you set uid=0, the engine generates a uid internally; on success, it triggers didJoinChannel callback
        agoraKit.joinChannel(byToken: token, channelId: channel, uid: 0, mediaOptions: options)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    func setupPiP() {
        guard AVPictureInPictureController.isPictureInPictureSupported() else {
            print("PiP not supported on this device")
            return
        }
        
        let playerLayer = AVPlayerLayer(player: nil)
        playerLayer.frame = localView.bounds
        localView.layer.addSublayer(playerLayer)
        
        pipController = AVPictureInPictureController(playerLayer: playerLayer)
        
        pipController?.delegate = self
    }
    
    @objc func togglePiP() {
//        if pipController?.isPictureInPictureActive == true {
//            pipController?.stopPictureInPicture()
//        } else {
//            pipController?.startPictureInPicture()
//        }
        guard let pipController = pipController else {
                print("pipController nil!")
                return
            }
            
            if pipController.isPictureInPicturePossible {
                print("PiP başlatılıyor...")
                pipController.startPictureInPicture()
            } else {
                print("PiP mümkün değil!")
            }
    }
}
// Extension for implementing AgoraRtcEngineDelegate methods
extension MeetingController: AgoraRtcEngineDelegate {
    
    // Callback when the local user successfully joins a channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print("didJoinChannel: (channel), uid: (uid)")
    }
    
    // Callback when a remote user joins the current channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        // When a remote user joins the channel, display the remote video stream with the specified uid
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = remoteView
        videoCanvas.renderMode = .hidden
        agoraKit.setupRemoteVideo(videoCanvas)
        
    }
    // Callback when a remote user leaves the current channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = nil
        agoraKit.setupRemoteVideo(videoCanvas)
    }
}
extension MeetingController: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PiP başladı")
    }
    
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print("PiP kapandı")
    }
}
