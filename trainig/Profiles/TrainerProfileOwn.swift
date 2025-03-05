//
//  TrainerProfile.swift
//  trainig
//
//  Created by omer yildirim on 2.02.2025.
//

import UIKit
import Kingfisher
import AVFoundation
class TrainerProfileOwn: UIViewController {

   
    @IBOutlet weak var plyBtn: UIButton!
    @IBOutlet weak var vView: BorderedViewNoBack!
    var views: [UIViewController] = []
    @IBOutlet weak var segment: CustomSegmented!
    @IBOutlet weak var vc: UIView!
    var position: Int = 0
    var trainerId:String!
    var trainerName:String!
    var trainerTitle:String!
    var trainerPhoto:Any!
    @IBOutlet weak var photo: RoundedImage!
    @IBOutlet weak var trainerNameTxt: UILabel!
    @IBOutlet weak var trainerTitleTxt: UILabel!
    let functions = Functions()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trainerNameTxt.text = trainerName
        trainerTitleTxt.text = trainerTitle
        let imageUrl:String? = trainerPhoto as? String ?? nil
        if let urlString = imageUrl, let url = URL(string: urlString) {
            photo.kf.setImage(with: url, placeholder: UIImage(named: "person"))
        } else {
            photo.image = UIImage(named: "person")
        }
        //getTrainerData()
        self.segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        self.segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        self.segment.setTitle(String(localized: "about"), forSegmentAt: 0)
        self.segment.setTitle(String(localized: "trainings"), forSegmentAt: 1)
        self.segment.setTitle(String(localized: "comments"), forSegmentAt: 2)
        self.segment.setTitle(String(localized: "specialities"), forSegmentAt: 3)
        let font = UIFont.systemFont(ofSize: 14, weight: .bold)
        segment.setTitleTextAttributes([NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        segment.setTitleTextAttributes([NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        vc.addGestureRecognizer(leftSwipe)
        vc.addGestureRecognizer(rightSwipe)
        
        
        setViewControllers()
       
        for i in 0 ..< views.count {
            let v=views[i]
            v.view.frame = CGRectMake(0, 0, self.vc.frame.size.width, self.vc.frame.size.height);
            self.vc.addSubview(v.view)
            v.didMove(toParent: self)
        }
        vc.bringSubviewToFront(views[0].view)
        getTrainerData()
        // Do any additional setup after loading the view.
    }
    var videoURL: URL!
    func getVideo(_ vUrl:String){
        var videoUrl:String? = vUrl
        videoUrl = videoUrl?.replacingOccurrences(of: "download?", with: "watch?")
        functions.getVideo(url: videoUrl!, onCompleteWithData: {(result,error) in
            if let url = String(data: result as! Data, encoding: .utf8) {
                videoUrl = url
            } else {
                return
            }
            DispatchQueue.main.async {
                if let urlString = videoUrl, let url = URL(string: urlString) {
                    self.videoURL = url
                    self.addVideoPlayer(videoUrl: url, to: self.view)
                    self.plyBtn.isHidden = false
                }
            }
        })
    }
    @IBAction func play(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "vp") as! VideoPlay
        vc.videoURL = videoURL
        present(vc, animated: true , completion: nil)
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
    func getTrainerData(){
        let data : Any = [
            "where": [
                "collectionName":"users",
                "and":[
                    "id":trainerId
                ]
            ]
        ]
        functions.getCollection(data: data, onCompleteWithData: { (d,error) in
            if d != nil {
                if (d as! NSArray).count>0 {
                    for i in d as! NSArray{
                        let collection = i as! NSDictionary
                        let content = collection["content"] as! NSDictionary
                        DispatchQueue.main.async {
                            self.getVideo(content["video"] as! String)
                        }
                        break
                    }
                    
                }
            }
        })
    }
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer)
    {
        if sender.direction == .left
        {
           
            if position < views.count-1{
                position = position + 1
                segment.selectedSegmentIndex = position
                bringToFront(index: position)
                
            }
        }

        if sender.direction == .right
        {
            if position > 0{
                position = position - 1
                segment.selectedSegmentIndex = position
                bringToFront(index: position)
            }
            
        }
    }
    func setViewControllers(){
        let about=storyboard?.instantiateViewController(withIdentifier: "about") as! AboutViewController
        about.id = trainerId
        let trns=storyboard?.instantiateViewController(withIdentifier: "trainings") as! TrainingTableViewController
        
        let ints=storyboard?.instantiateViewController(withIdentifier: "intsCol") as! InterestCollectionView
        ints.id = trainerId
        ints.forTrainer=true
        let comment=storyboard?.instantiateViewController(withIdentifier: "comTab") as! CommentController
        comment.id = trainerId
        comment.forTrainer=true
        views.append(about)
        views.append(trns)
        views.append(comment)
        views.append(ints)
    }
    @IBAction func segment_changed(_ sender: Any) {
        bringToFront(index: segment.selectedSegmentIndex)
    }
    func bringToFront(index:Int){
        for v in views{
            v.view.alpha = 0
        }
        views[index].view.alpha = 1
        
        vc.bringSubviewToFront(views[index].view)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
