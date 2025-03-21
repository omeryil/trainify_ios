//
//  TrainerProfile.swift
//  trainig
//
//  Created by omer yildirim on 2.02.2025.
//

import UIKit
import Kingfisher
class TrainerProfile: UIViewController {

    @IBOutlet weak var trainerTitle: UILabel!
    @IBOutlet weak var trainerName: UILabel!
    @IBOutlet weak var total_title: UILabel!
    @IBOutlet weak var monthly_title: UILabel!
    @IBOutlet weak var total_text: UILabel!
    @IBOutlet weak var monthly_text: UILabel!
    var views: [UIViewController] = []
    @IBOutlet weak var segment: CustomSegmented!
    @IBOutlet weak var vc: UIView!
    var position: Int = 0
    let functions=Functions()
    var userData:NSMutableDictionary!
    @IBOutlet weak var profile_photo: RoundedImage!
    var first: Bool = true
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        userData=CacheData.getUserData()!
       
        self.segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        self.segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        self.segment.setTitle(String(localized: "about"), forSegmentAt: 0)
        self.segment.setTitle(String(localized: "sold"), forSegmentAt: 1)
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
        total_title.text=String(localized: "total_profit")
        monthly_title.text=String(localized: "monthly_profit")
        getProfit()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        first=false
    }
    override func viewWillAppear(_ animated: Bool) {
        userData=CacheData.getUserData()!
        trainerName.text = userData["name"] as? String ?? ""
        trainerTitle.text = userData["title"] as? String ?? ""
        let imageUrl:String? = userData["photo"] as? String ?? nil
        if let urlString = imageUrl, let url = URL(string: urlString) {
            profile_photo.kf.setImage(with: url, placeholder: UIImage(named: "person"))
        } else {
            profile_photo.image = UIImage(named: "person")
        }
        if !first{
            views[selectedIndex].viewWillAppear(false)
        }
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
        about.id = userData["id"] as? String
        let trns=storyboard?.instantiateViewController(withIdentifier: "trainings") as! TrainingTableViewController
        
        let ints=storyboard?.instantiateViewController(withIdentifier: "intsCol") as! InterestCollectionView
        ints.id = userData["id"] as? String
        ints.forTrainer=true
        let comment=storyboard?.instantiateViewController(withIdentifier: "comTab") as! CommentController
        comment.id = userData["id"] as? String
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
        views[index].viewWillAppear(false)
        selectedIndex = index
    }
    @IBAction func settings_cl(_ sender: Any) {
        let n = storyboard?.instantiateViewController(withIdentifier: "sett") as! SettingsController
        n.forTrainer=true
        self.navigationController!.pushViewController(n, animated: true)
        
    }
    func getProfit(){
        let id = userData["id"]
        let data : Any =
        [
            "where": [
                "collectionName": "users",
                "and":[
                    "id": id
                ]
            ],
            "related": [
                "relationName": "trainerProfitRelation",
                "where": [
                    "collectionName": "trainerProfit"
                ]
            ]
        ]
        functions.getRelationsOneContent(data: data, listItem:"trainerProfit", onCompleteWithData: { (contentData,error) in
            if contentData != nil {
                let content=contentData as! NSDictionary
                let currency=content["currency"] as! String
                let totalprofit=String(content["totalprofit"] as! Int64)
                let profit=String(content["profit"] as! Int64)
                DispatchQueue.main.async {
                    self.total_text.text=currency+totalprofit
                    self.monthly_text.text=currency+profit
                }
            }else{
                if error == PostGet.no_connection {
                    DispatchQueue.main.async {
                        PostGet.noInterneterror(v: self)
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                //self.view.dismissLoader()
            }
        })
        
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
