//
//  VideoPlay.swift
//  trainig
//
//  Created by omer yildirim on 3.02.2025.
//

import UIKit
import AVKit

class VideoPlay: AVPlayerViewController {
    var videoURL: URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        player = AVPlayer(url: videoURL)
        player?.play()
        // Do any additional setup after loading the view.
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
