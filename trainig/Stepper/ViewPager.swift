//
//  ViewPager.swift
//  trainig
//
//  Created by omer yildirim on 28.01.2025.
//

import UIKit

class ViewPager: UIViewController,UIScrollViewDelegate,StepperDelegate,indicatorDelegate {
    func personalInfo(data: Any) {
        personalInfoData=data
    }
    
    func interests(data: Any) {
        interestData=data
    }
    func provideo(data: Any) {
        videoData=data
    }
    
    func about(data: Any) {
        aboutData = data
    }
    
    func certificate(data: Any) {
        certificateData = data
    }
    
    var ind:Indicator!
    func showIndicator() {
        ind = self.view.showLoader(String(localized:"wait"))!
    }
    
    func hideIndicator() {
        self.view.dismissLoader()
    }
    
    
    

    @IBOutlet weak var actionBtn: CustomButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    var views: [UIViewController] = []
    var position:Int=0
    var userData : NSMutableDictionary!
    var personalInfoData : Any!
    var interestData : Any!
    var videoData : Any!
    var certificateData : Any!
    var aboutData : Any!
    let functions = Functions()
    var mFields:[Any] = []
    var isTrainer:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionBtn.setTitle(String(localized: "next"), for: .normal)
        actionBtn.setTitle(String(localized: "next"), for: .selected)
        
        userData = CacheData.getUserData()!
        isTrainer = userData["role"] as! String == "trainer"
        scrollView.delegate=self
        scrollView.isPagingEnabled = true
        self.scrollView.frame.size.width = self.view.frame.width
        scrollView.clipsToBounds = true
        
        self.view.bringSubviewToFront(pageControl)
        //scrollView.addSubview(PersonalInfo().view)
        // Do any additional setup after loading the view.
        setViewControllers()
       
        for i in 0 ..< views.count {
            let v=views[i]
            self.addChild(v)
            self.scrollView.addSubview(v.view)
            v.willMove(toParent: self)
            v.view.frame = CGRect(x: self.view.frame.width * CGFloat(i), y: 0, width: self.view.frame.width, height: scrollView.frame.height)
        
        }
        pageControl.numberOfPages=views.count
        pageControl.currentPage=0
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
            
        leftSwipe.direction = .left
        rightSwipe.direction = .right

        scrollView.addGestureRecognizer(leftSwipe)
        scrollView.addGestureRecognizer(rightSwipe)
        
    }
    @IBAction func action(_ sender: Any) {
        if position < views.count-2 {
            next()
        }else if position < views.count-1 {
            next()
        }else {
            start()
        }
    }
    func uploadProfilePhoto(fileURL:URL,onCompleteWithData:@escaping Functions.OnCompleteWithData){
        
        functions.upload(data: fileURL, onCompleteWithData: {(result,error) in
            if result != nil{
                onCompleteWithData(result,error)
            }else {
                print(error!)
            }
        })
    }
    func uploadPromotionVideo(fileURL:URL,onCompleteWithData:@escaping Functions.OnCompleteWithData){
        
        functions.upload(data: fileURL, onCompleteWithData: {(result,error) in
            if result != nil{
                onCompleteWithData(result,error)
            }else {
                print(error!)
            }
        })
    }
    
    func updatePhotoOrVideo(id:String,dict:Any,onCompleteBool:@escaping Functions.OnCompleteBool){
        let data:Any = [
            "where": [
                "collectionName": "users",
                "and": [
                    "id": id
                ]
            ],
            "fields": dict
        ]
        
        self.functions.update(data: data, onCompleteBool: { (success,error) in
            onCompleteBool(success!,error!)
           
        })
    }
    func addFeatures(id:String,dict:NSDictionary,onCompleteBool:@escaping Functions.OnCompleteBool)
    {
        let trainerItems:[String] = ["gender","birthdate","height","weight","expstarted","title","rating"]
        let userItems:[String] = ["gender","birthdate","height","weight"]
        
        var fields : [Any] = []
        var list = isTrainer ? trainerItems : userItems
        
        for i in list {
            let item : Any = [
                "field": i,
                "value": dict[i],
            ]
            fields.append(item)
        }
        let isFirst : Any = [
            "field": "isFirst",
            "value": false,
        ]
        fields.append(isFirst)
        let data : Any = [
            "where": [
                "collectionName": "users",
                "and": [
                    "id": userData["id"]
                ]
            ],
            "fields":fields
        ]
        functions.update(data: data, onCompleteBool: {(success, error) in
           
            self.userData["gender"] = dict["gender"]
            self.userData["birthdate"] = dict["birthdate"]
            self.userData["height"] = dict["height"]
            self.userData["weight"] = dict["weight"]
            self.userData["expstarted"] = dict["expstarted"]
            self.userData["rating"] = CGFloat(0)
            self.userData["isFirst"] = false
            if self.isTrainer {
                self.userData["title"] = dict["title"]
            }
            
            CacheData.saveUserData(data: self.userData)
            onCompleteBool(success!,error!)
        })
    }
    func addInterests(id:String,onCompleteBool:@escaping Functions.OnCompleteBool)
    {

        let dict = interestData as! NSDictionary
        let arr = dict["items"] as! NSArray
        var fields:[Any] = []
        for i in arr {
            var c : Any = []
            if isTrainer {
                c = [
                    "spec": i,
                    "year":0,
                    "createdDate": Int64(Date().timeIntervalSince1970*1000)
                ]
            }else {
                c = [
                    "interest": i,
                    "createdDate": Int64(Date().timeIntervalSince1970*1000)
                ]
            }
            let d : Any = [
                "collectionName": !isTrainer ? "userinterest" : "trainerSpecs",
                "content":c
            ]
            fields.append(d)
        }
        let data : Any = [
            "relations": [
                [
                    "id": id,
                    "collectionName":"users",
                    "relationName": !isTrainer ? "userInterestRelation" : "trainerSpecsRelation"
                ]
            ],
            "contents": fields
        ]
        functions.addRelations(data: data, onCompleteBool: {(success, error) in
            onCompleteBool(success!,error!)
            if error == PostGet.no_connection {
                DispatchQueue.main.async {
                    PostGet.noInterneterror(v: self)
                }
                return
            }
        })
    }
    func hasValidPersonalData(_ data: Any?) -> Bool {
        guard let dict = data as? NSDictionary else { return false }
        return true
    }
    func start() {
        
        let id = userData["id"] as! String
        var str = ""
        var err_mes = ""
        if !hasValidPersonalData(personalInfoData){
            str = "choose_gender_error"
            err_mes = String(localized:String.LocalizationValue(str))
            functions.createAlert(self: self, title: String(localized:"error"), message: err_mes, yesNo: false, alertReturn: { result in
                
            })
            return
        }
        let dict = personalInfoData as! NSDictionary
        var continue_=false
        var elements:[String]!
        if isTrainer{
            elements=["gender","birthdate","expstarted","title","weight","height"]
        }else{
            elements=["gender","birthdate","weight","height"]
        }
        for i in elements {
            if let value = dict.value(forKey: i), !(value is NSNull) {
                if let stringValue = value as? String, !stringValue.isEmpty {
                    continue_ = true
                } else if let intValue = value as? Int, intValue != 0 {
                    continue_ = true
                } else {
                    continue_ = false
                    break
                }
            }else{
                continue_ = false
                break
            }
        }
        
        if !continue_ {
            str = "choose_personal_error"
            err_mes = String(localized:String.LocalizationValue(str))
            functions.createAlert(self: self, title: String(localized:"error"), message: err_mes, yesNo: false, alertReturn: { result in
                                  
                })
            return
        }
        let group = DispatchGroup()
        ind = self.view.showLoader(String(localized:"wait"))!
        var mFields:[Any] = []
        if dict["photo"] != nil {
            group.enter()
            uploadProfilePhoto(fileURL: dict["photo"] as! URL, onCompleteWithData: {
                (result,error) in
                defer { group.leave() }
                if result != nil {
                    DispatchQueue.main.async {
                        self.ind.lbl.text = "Profile Photo Uploaded"
                    }
                    let response = result as! response
                    let json = response.JsonObject
                    let dd = json!["data"] as! NSDictionary
                    let url = dd["url"] as! String
                    let photo = Statics.osService + url
                    let d : Any = ["field":"photo","value":photo]
                    mFields.append(d)
                    self.userData["photo"] = photo
                    CacheData.saveUserData(data: self.userData)
                    self.updatePhotoOrVideo(id: id, dict: mFields as Any, onCompleteBool: { (success,error) in
                        if success! {
                            DispatchQueue.main.async {
                                self.ind.lbl.text = "Profile Photo Updated"
                            }
                            
                        }else {
                            DispatchQueue.main.async {
                                self.ind.lbl.text = "Profile Photo Update Error" + error!
                            }
                            print(error!)
                        }
                        
                    })
                }else{
                    
                }
            })
           
        }
        group.enter()
        self.addFeatures(id: id, dict: dict, onCompleteBool: { (success,error) in
            defer { group.leave() }
            if success! {
                DispatchQueue.main.async {
                    self.ind.lbl.text = "Features Added"
                }
               
            }else {
                DispatchQueue.main.async {
                    self.ind.lbl.text = "Features Add Error" + error!
                }
                print(error!)
            }
            
           
        })
        if interestData != nil {
            group.enter()
            self.addInterest(id: id, dict: dict,onCompleteBool: {s,e in
                defer { group.leave() }
            })
        }
        if self.userData["role"] as! String == "trainer" {
            group.enter()
            self.addAbout(id: id, dict: dict,onCompleteBool: {s,e in
                defer { group.leave() }
            })
            group.enter()
            self.addProfit(id: id, dict: dict,onCompleteBool: {s,e in
                defer { group.leave() }
            })
            if videoData != nil {
                group.enter()
                self.addVideo(id: id, dict: dict,onCompleteBool: {s,e in
                    defer { group.leave() }
                })
            }
        }
        // Tüm işlemler tamamlandığında çalışacak kod
        group.notify(queue: DispatchQueue.main) {
            self.forward()
        }
    }
    
    func addVideo(id:String,dict:Any,onCompleteBool:@escaping Functions.OnCompleteBool){
        var mf:[Any]=[]
        uploadPromotionVideo(fileURL: videoData as! URL, onCompleteWithData: {
            (result,error) in
            if result != nil {
                DispatchQueue.main.async {
                    self.ind.lbl.text = "Promotion Video Uploaded"
                }
                let response = result as! response
                let json = response.JsonObject
                let dd = json!["data"] as! NSDictionary
                let url = dd["url"] as! String
                let video = Statics.osService + url
                let d : Any = ["field":"video","value":video]
                mf.append(d)
                self.userData["video"] = video
                CacheData.saveUserData(data: self.userData)
                self.updatePhotoOrVideo(id: id, dict: mf as Any, onCompleteBool: { (success,error) in
                    if success! {
                        DispatchQueue.main.async {
                            self.ind.lbl.text = "Promotion Video  Updated"
                        }
                        
                    }else {
                        DispatchQueue.main.async {
                            self.ind.lbl.text = "Promotion Video Update Error" + error!
                        }
                        print(error!)
                    }
                    onCompleteBool(success!,error!)
                })
            }else{
                onCompleteBool(false,error!)
            }
            
        })
    }

    func addInterest(id:String,dict:Any,onCompleteBool:@escaping Functions.OnCompleteBool){
        let d = interestData as! NSDictionary
        if d.object(forKey: "items") != nil  && (d["items"] as! [String]).count>0{
            self.addInterests(id: id, onCompleteBool: { (success,error) in
                if success! {
                    DispatchQueue.main.async {
                        self.ind.lbl.text = "Interests Added"
                    }
                   
                }else {
                    DispatchQueue.main.async {
                        self.ind.lbl.text = "Interests Add Error" + error!
                    }
                    print(error!)
                }
                onCompleteBool(true, "")
            })
        }else{
            onCompleteBool(true, "")
        }
    }
    func addAbout(id:String,dict:Any,onCompleteBool:@escaping Functions.OnCompleteBool){
        var data : Any =
        [
            "relations": [
                [
                    "id": id,
                    "collectionName":"users",
                    "relationName": "trainerAboutRelation"
                ]
            ],
            "contents": [
                [
                    "collectionName": "trainerAbout",
                    "content": [
                        "about": self.aboutData != nil ? self.aboutData as! String : "",
                        "createdDate": Int64(Date().timeIntervalSince1970*1000)
                    ]
                ]
            ]
        ]
        
        functions.addRelations(data: data, onCompleteBool: { (success,error) in
            if success! {
                DispatchQueue.main.async {
                    self.ind.lbl.text = "About Added"
                }
               
            }else {
                DispatchQueue.main.async {
                    self.ind.lbl.text = "About Add Error" + error!
                }
                if error == PostGet.no_connection {
                    DispatchQueue.main.async {
                        PostGet.noInterneterror(v: self)
                    }
                    return
                }
            }
            onCompleteBool(success!,error)
        })
        
    }
    func addCertificate(id:String,dict:Any){
        
    }
    func addProfit(id:String,dict:Any,onCompleteBool:@escaping Functions.OnCompleteBool){
        let data : Any = [
            "relations": [
                [
                    "id": id,
                    "collectionName":"users",
                    "relationName": "trainerProfitRelation"
                ]
            ],
            "contents": [
                [
                    "collectionName": "trainerProfit",
                    "content": [
                        "totalprofit":0,
                        "profit": 0,
                        "currency":"₺",
                        "lastdate":Int64(Date().timeIntervalSince1970*1000),
                        "createdDate": Int64(Date().timeIntervalSince1970*1000)
                    ]
                ]
            ]
        ]
        functions.addRelations(data: data, onCompleteBool: { (success,error) in
            if success! {
                DispatchQueue.main.async {
                    self.ind.lbl.text = "Profit Added"
                }
               
            }else {
                DispatchQueue.main.async {
                    self.ind.lbl.text = "Profit Add Error" + error!
                }
                if error == PostGet.no_connection {
                    DispatchQueue.main.async {
                        PostGet.noInterneterror(v: self)
                    }
                    return
                }
            }
            onCompleteBool(success!,error!)
            
        })
    }
    func forward(){
        let role = userData["role"] as! String
        var n : UIViewController!
        if role=="user"{
            n = storyboard?.instantiateViewController(withIdentifier: "upage") as! UserTabViewController
        }else{
            n = storyboard?.instantiateViewController(withIdentifier: "tpage") as! TrainerTabViewController
        }
        self.navigationController!.pushViewController(n, animated: true)
    }
    func next(){
        if position < views.count-2 {
            position = position + 1
            scrollView.setContentOffset(CGPoint(x: CGFloat(position) * scrollView.frame.size.width, y: 0), animated: true)
            pageControl.currentPage=position
            actionBtn.setTitle(String(localized: "next"), for: .normal)
            actionBtn.setTitle(String(localized: "next"), for: .selected)
        }else if position < views.count-1 {
            position = position + 1
            scrollView.setContentOffset(CGPoint(x: CGFloat(position) * scrollView.frame.size.width, y: 0), animated: true)
            pageControl.currentPage=position
            actionBtn.setTitle(String(localized: "letsstart"), for: .normal)
            actionBtn.setTitle(String(localized: "letsstart"), for: .selected)
        }
    }
    func prev(){
        position = position - 1
        scrollView.setContentOffset(CGPoint(x: CGFloat(position) * scrollView.frame.size.width, y: 0), animated: true)
        pageControl.currentPage=position
        actionBtn.setTitle(String(localized: "next"), for: .normal)
        actionBtn.setTitle(String(localized: "next"), for: .selected)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
       
    }
  
    func setViewControllers(){
        //let d : [String:Any ]=["role":"trainer"]
        //userData=d as! NSDictionary
        let pi=storyboard?.instantiateViewController(withIdentifier: "pi") as! PersonalInfo
        pi.isStepperOn=true
        pi.stepperDelegate=self
        let interest=storyboard?.instantiateViewController(withIdentifier: "ints") as! Interests
        interest.isStepperOn=true
        interest.stepperDelegate=self
        interest.isTrainer=isTrainer
        let about=storyboard?.instantiateViewController(withIdentifier: "abt") as! UpdateAboutViewController
        about.isStepperOn=true
        about.delegate=self
        let provideo=storyboard?.instantiateViewController(withIdentifier: "upVideo") as! UpdateVideoViewController
        provideo.isStepperOn=true
        provideo.delegate=self
        let certificates=storyboard?.instantiateViewController(withIdentifier: "certs") as! Certificates
    
        certificates.isStepperOn=true
        certificates.stepperDelegate=self
        views.append(pi)
        
        if userData["role"] as! String == "trainer" {
            views.append(provideo)
            views.append(about)
            //views.append(certificates)
        }
        views.append(interest)
    }
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer)
    {
        if sender.direction == .left
        {
           
            if position < views.count-1{
                next()
                
            }
        }

        if sender.direction == .right
        {
            if position > 0{
                prev()
            }
            
        }
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        let current=((sender as AnyObject).currentPage)!
        position=current
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * scrollView.frame.size.width, y: 0), animated: true)
        if position < views.count-2 {
            actionBtn.setTitle(String(localized: "next"), for: .normal)
            actionBtn.setTitle(String(localized: "next"), for: .selected)
        }else if position < views.count-1 {
            actionBtn.setTitle(String(localized: "letsstart"), for: .normal)
            actionBtn.setTitle(String(localized: "letsstart"), for: .selected)
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
