//
//  Testt.swift
//  trainig
//
//  Created by omer yildirim on 4.02.2025.
//

import UIKit
import AVFoundation

class Testt: UIViewController {
    @IBOutlet weak var previewView: UIImageView!
    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSession.Preset.photo
        let backCamera =  AVCaptureDevice.default(for: AVMediaType.video)
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera!)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey:  AVVideoCodecJPEG]
            if session!.canAddOutput(stillImageOutput!) {
                session!.addOutput(stillImageOutput!)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
                videoPreviewLayer!.videoGravity =    AVLayerVideoGravity.resizeAspect
                videoPreviewLayer!.connection?.videoOrientation =   AVCaptureVideoOrientation.portrait
                previewView.layer.addSublayer(videoPreviewLayer!)
                session!.startRunning()
            }
        }
    }
         
    @IBOutlet weak var btn: UIButton!
    @IBAction func clc(_ sender: Any) {
        let cameraVc = UIImagePickerController()
        cameraVc.sourceType = UIImagePickerController.SourceType.camera
        self.present(cameraVc, animated: true, completion: nil)
       
        //self.present(navigationController, animated: true, completion: nil)
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
                DispatchQueue.main.async {
                    let cameraVc = UIImagePickerController()
                    cameraVc.sourceType = UIImagePickerController.SourceType.camera
                    self.present(cameraVc, animated: true, completion: nil)
                }
                
            }
            
        }
       
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
