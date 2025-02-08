//
//  UpdateIVideoViewController.swift
//  trainig
//
//  Created by omer yildirim on 3.02.2025.
//

import UIKit
import AVKit

class UpdateVideoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    let imagePickerController = UIImagePickerController()
    var videoURL: URL!
    @IBOutlet weak var plyBtn: UIButton!
    @IBOutlet weak var pickButton: CustomButton!
    @IBOutlet weak var vView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        plyBtn.isHidden = true
        self.title=String(localized:"promotion_video")
    }
    @IBAction func play(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "vp") as! VideoPlay
        vc.videoURL = videoURL
        present(vc, animated: true , completion: nil)
    }
    @IBAction func selectVideo(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]

        present(imagePickerController, animated: true, completion: nil)
    }
    
    func addVideoPlayer(videoUrl: URL, to view: UIView) {
        let player = AVPlayer(url: videoUrl)
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = vView.bounds
        layer.videoGravity = .resizeAspectFill
        vView.layer.sublayers?
            .filter { $0 is AVPlayerLayer }
            .forEach { $0.removeFromSuperlayer()
        }
        vView.layer.insertSublayer(layer, at: 0)
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
        self.videoURL = url
        addVideoPlayer(videoUrl: url, to: view)
        plyBtn.isHidden = false
        dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(update))

    }
    @objc func update(_ button: UIBarButtonItem?) {
        
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
