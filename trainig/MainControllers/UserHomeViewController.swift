//
//  UserHomeViewController.swift
//  trainig
//
//  Created by omer yildirim on 1.02.2025.
//

import UIKit
import Kingfisher

class UserHomeViewController: UIViewController {

    @IBOutlet weak var recommendedTable: UITableView!
    @IBOutlet weak var upcomingCollection: UICollectionView!
    
    @IBOutlet weak var noUpcoming: UILabel!
    @IBOutlet weak var noresult: UILabel!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var profile_image: RoundedImage!
    var upcomingList: [UpcomingItem] = []
    var recommendedList: [RecommendedTrainerItem] = []
    var userData:NSMutableDictionary!
    var interests:[String]=[]
    let functions = Functions()
    override func viewDidLoad() {
        super.viewDidLoad()
        userData=CacheData.getUserData()!
        
        upcomingCollection.delegate = self
        upcomingCollection.dataSource = self
        
        recommendedTable.delegate = self
        recommendedTable.dataSource = self
        
        //loadUpcomingList()
        getUpcomingData(ind: true)
        getInterestData()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: self.view.frame.width*0.8, height: 122)
        upcomingCollection.collectionViewLayout=layout
        noresult.text=String(localized:"no_result")
        noUpcoming.text=String(localized:"no_upcoming")
        
        recommendedTable.addRefreshControl(target: self, action: #selector(refreshData))
        // Do any additional setup after loading the view.
    }
    @objc func refreshData() {
        self.getInterestData()
    }
    override func viewWillAppear(_ animated: Bool) {
        userData=CacheData.getUserData()!
        let imageUrl:String? = userData["photo"] as? String ?? nil
        if let urlString = imageUrl, let url = URL(string: urlString) {
            profile_image.kf.setImage(with: url, placeholder: UIImage(named: "person"))
        } else {
            profile_image.image = UIImage(named: "person")
        }
        fullname.text=String(localized:"hi") + "! " + (userData["name"] as! String)
        getUpcomingData(ind: false)
        
    }
    func getUpcomingData(ind:Bool){
        if ind{
            self.view.showLoader(String(localized:"wait"))
        }
        let now = Statics.currentTimeInMilliSeconds()
        let d = Date()
        let afterThreeDaysDate = Calendar.current.date(byAdding: .day, value: 3, to: d)
        let afterThreeDaysDateInMilliSeconds = Statics.currentTimeInMilliSeconds(date: afterThreeDaysDate!)
        let dta:Any=[
            "usid":userData["id"],
            "start":now,
            "finish":afterThreeDaysDateInMilliSeconds
        ]
        functions.executeUserUpcoming(data: dta, onCompleteWithData: { (contentData,error) in
            let resData=contentData as? NSArray ?? []
            if error!.isEmpty {
                for item in resData{
                    let itemTop = item as! NSDictionary
                    let soldId = itemTop["id"] as! String
                    let content = itemTop["content"] as! NSDictionary
                    let adscontent = itemTop["adscontent"] as! NSDictionary
                    let trainerId = adscontent["trainer_id"] as! String
                    let usercontent = itemTop["usercontent"] as! NSDictionary
                    let training_name = adscontent["training_title"] as? String ?? ""
                    let trainer_name = usercontent["name"] as? String ?? ""
//                    let time = "\(adscontent["date"] as? String ?? "") \(adscontent["start_time"] as? String ?? "") - \(adscontent["end_time"] as? String ?? "") "
                    let photo = usercontent["photo"]
                    
                    let startD = content["startDate"] as! Int64
                    let endD = content["endDate"] as! Int64
                    let startHHmm = Statics.formatTimeFromLong(timestamp: startD)
                    let endHHmm = Statics.formatTimeFromLong(timestamp: endD)
                    let strdate = Statics.formatDateFromLong(timestamp: startD)
                    
//                    let adscontent = itemTop["adscontent"] as! NSDictionary
//                    let usercontent = itemTop["usercontent"] as! NSDictionary
                    
                    let time = "\(strdate) \(startHHmm) - \(endHHmm) "
                    
                    if !self.upcomingList.contains(where: { $0.time == time && $0.trainer_name == trainer_name }){
                        self.upcomingList.append(UpcomingItem( training_name:training_name,trainer_name: trainer_name, duration: "", time: time,photo: photo,soldId: soldId,trainerId: trainerId))
                    }
                   
                }
                DispatchQueue.main.async {
                    self.noUpcoming.isHidden = self.upcomingList.count > 0
                    self.upcomingCollection.reloadData()
                }
            }else{
                if error == PostGet.no_connection {
                    DispatchQueue.main.async {
                        PostGet.noInterneterror(v: self)
                    }
                }
                
            }
        })
    }
    func getInterestData(){
       
        let id=userData["id"]
        let data:Any=[
            "where": [
                "collectionName": "users",
                "and":[
                    "id":id
                ]
            ],
            "related": [
                "relationName": "userInterestRelation",
                "where": [
                    "collectionName": "userInterest"
                ]
            ]
        ]
        functions.getRelations(data: data,listItem:"userInterest", onCompleteWithData: { (contentData,error) in
            let resData=contentData as? NSArray ?? []
            if error!.isEmpty {
                
                for item in resData{
                    let itemDic = item as! NSDictionary
                    let content = itemDic["content"] as! NSDictionary
                    let i=content["interest"] as? String ?? ""
                    self.interests.append(i)
                }
                
            }else{
                if error == PostGet.no_connection {
                    DispatchQueue.main.async {
                        PostGet.noInterneterror(v: self)
                    }
                }
                
            }
            DispatchQueue.main.async {
                //self.addData()
                self.getFeatured()
            }
        })
        
    }
    
    func getFeatured(){
        let data : Any = [
            "interests":interests
        ]
        recommendedList.removeAll()
        functions.featured(data: data, onCompleteWithData: { (data,error) in
            if error == PostGet.no_connection {
                DispatchQueue.main.async {
                    PostGet.noInterneterror(v: self)
                    self.view.dismissLoader()
                }
                return
            }
            DispatchQueue.main.async {
                self.loadsearchList(data as! [NSDictionary])
                self.view.dismissLoader()
            }
            
        })
    }
    func loadsearchList(_ data:[NSDictionary]){
        
        if data.count==0{
            noresult.isHidden=false
        }else {
            noresult.isHidden=true
        }
        for item in data{
            recommendedList.append(RecommendedTrainerItem(trainer_title: item["trainertitle"] as? String, trainer_name: item["trainername"] as? String, exps: item["trainerExps"] as? [String], photo: item["trainerphoto"], rating: item["trainerrating"] as? Float,trainerId: item["trainerid"] as? String))
        }
        recommendedTable.reloadData()
        recommendedTable.refreshControl?.endRefreshing()
    }
    func enterMeeting(_ item:UpcomingItem){
        let data : Any = [
            "where": [
                "collectionName": "sold",
                "and": [
                    "id": item.soldId
                ]
            ]
        ]
        functions.getCollection(data: data, onCompleteWithData: { (d,error) in
            if error == PostGet.no_connection {
                DispatchQueue.main.async {
                    PostGet.noInterneterror(v: self)
                }
                return
            }
            if d != nil {
                for i in d as! [[String:Any]] {
                    let id = i["id"] as! String
                    let content = i["content"] as! [String:Any]
                    let token = content["token"] as! String
                    if token.isEmpty{
                        DispatchQueue.main.async {
                            self.functions.createAlert(self: self, title: String(localized:"info"), message: String(localized:"meeting_not_started"), yesNo: false, alertReturn: { result in
                            })
                        }
                        return
                    }else{
                        DispatchQueue.main.async {
                            let n = self.storyboard?.instantiateViewController(withIdentifier: "meet") as! MeetingController
                            n.channel = item.trainerId
                            n.token = token
                            self.navigationController?.pushViewController(n, animated: true)
                        }
                        
                    }
                    break
                }
            }else{
                DispatchQueue.main.async {
                    self.functions.createAlert(self: self, title: String(localized:"info"), message: String(localized:"meeting_not_started"), yesNo: false, alertReturn: { result in
                    })
                }
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
extension UserHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return upcomingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upCell", for: indexPath) as? UpcomingCell else {
            return UICollectionViewCell()
            
        }
        cell.configure(with: upcomingList[indexPath.row])
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = upcomingList[indexPath.row]
        enterMeeting(item)
    }
    
    
}
extension UserHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recTCell", for: indexPath) as? RecommendedTrainerCell else {
            return UITableViewCell()
        }
        cell.configure(with: recommendedList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RecommendedTrainerCell {
            cell.backgroundColor = UIColor(named: "DarkCellBack")
          }
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RecommendedTrainerCell {
            cell.backgroundColor = UIColor.clear
          }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = recommendedList[indexPath.row]
        let n = storyboard?.instantiateViewController(withIdentifier: "t_ownprofile") as! TrainerProfileOwn
        n.trainerId = item.trainerId
        n.trainerName = item.trainer_name
        n.trainerTitle = item.trainer_title
        n.trainerPhoto = item.photo
        self.navigationController!.pushViewController(n, animated: true)
    }
          
    
}
