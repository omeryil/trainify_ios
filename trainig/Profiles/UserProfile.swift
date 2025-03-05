//
//  UserProfile.swift
//  trainig
//
//  Created by omer yildirim on 31.01.2025.
//

import UIKit

class UserProfile: UIViewController {
    
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var profile_photo: RoundedImage!
    @IBOutlet weak var ageTitle: UILabel!
    @IBOutlet weak var weightTitle: UILabel!
    @IBOutlet weak var heightTitle: UILabel!
    @IBOutlet weak var heightText: UILabel!
    @IBOutlet weak var ageText: UILabel!
    @IBOutlet weak var weightText: UILabel!
    var views: [UIViewController] = []
    @IBOutlet weak var segment: CustomSegmented!
    @IBOutlet weak var vc: UIView!
    var position: Int = 0
    var userData:NSDictionary!
    let functions=Functions()
    override func viewDidLoad() {
        super.viewDidLoad()
        userData=CacheData.getUserData()!
        
        self.segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        self.segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        self.segment.setTitle(String(localized: "interests"), forSegmentAt: 0)
        self.segment.setTitle(String(localized: "comments"), forSegmentAt: 1)
        let font = UIFont.systemFont(ofSize: 16, weight: .bold)
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
        ageTitle.text=String(localized: "age")
        weightTitle.text=String(localized: "weight")
        heightTitle.text=String(localized: "height")
        ageText.text="30" + " " + String(localized: "yrs_short")
        weightText.text="55.0 kg"
        heightText.text="172 cm"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
       
        getUserFeatures()
       
       
        let imageUrl:String? = userData["photo"] as? String ?? nil
        if let urlString = imageUrl, let url = URL(string: urlString) {
            profile_photo.kf.setImage(with: url, placeholder: UIImage(named: "person"))
        } else {
            profile_photo.image = UIImage(named: "person")
        }
       
        fullname.text=(userData["name"] as! String)
    }
    @IBAction func settings_cl(_ sender: Any) {
        let n = storyboard?.instantiateViewController(withIdentifier: "sett") as! SettingsController
        n.forTrainer=false
        self.navigationController!.pushViewController(n, animated: true)
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
        let ints=storyboard?.instantiateViewController(withIdentifier: "intsCol") as! InterestCollectionView
        ints.id = userData["id"] as? String
        let comment=storyboard?.instantiateViewController(withIdentifier: "comTab") as! CommentController
        comment.id = userData["id"] as? String
        views.append(ints)
        views.append(comment)
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
    }
    var indicator:Indicator!
    func getUserFeatures(){
        indicator = self.view.showLoader(nil)
        indicator?.lbl.text = String(localized:"wait")
        let id=userData["id"]
        let data:Any=[
                "where": [
                    "collectionName": "users",
                    "and":[
                        "id":id
                    ]
                ],
                "related": [
                    "relationName": "userFeatureRelation",
                    "where": [
                        "collectionName": "userFeature"
                    ]
                ]
        ]
        functions.getRelationsOneContent(data: data,listItem:"userFeature", onCompleteWithData: { (contentData,error) in
            if contentData != nil {
                let content=contentData as! NSDictionary
                DispatchQueue.main.async {
                    self.heightText.text=content["height"] as? String
                    self.weightText.text=content["weight"] as? String
                    self.ageText.text=Statics.yearsDifference(from: content["birthdate"] as! TimeInterval)! + " " + String(localized:"yrs_short")
                }
            }else{
                print(error!)
            }
            DispatchQueue.main.async {
                self.view.dismissLoader()
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
